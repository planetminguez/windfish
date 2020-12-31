import Foundation

/**
 A representation of the LR35902 CPU at a specific moment.

 All registers are optional, allowing for the representation of registers being in an unknown state in order to
 support emulation of a block of instructions that might be reached from unknown locations or a variety of states.
 */
public final class LR35902 {
  public typealias Address = UInt16

  public final class MachineInstruction {
    enum MicroCodeResult {
      case continueExecution
      case fetchNext
      case fetchPrefix
    }
    typealias MicroCode = (LR35902, AddressableMemory, Int, Disassembler.SourceLocation) -> MicroCodeResult

    final class LoadedInstruction {
      internal init(spec: LR35902.Instruction.Spec, microcode: @escaping LR35902.MachineInstruction.MicroCode, sourceLocation: Disassembler.SourceLocation) {
        self.spec = spec
        self.microcode = microcode
        self.sourceLocation = sourceLocation
      }

      let spec: Instruction.Spec
      let microcode: MicroCode
      let sourceLocation: Disassembler.SourceLocation
    }

    internal init() {}

    internal init(spec: LR35902.Instruction.Spec, sourceLocation: Disassembler.SourceLocation) {
      if case var .interrupt(interrupt) = spec {
        self.loaded = LoadedInstruction(
          spec: spec,
          microcode: { (cpu, memory, cycle, sourceLocation) in
            if cycle == 1 {
              cpu.sp -= 1
              memory.write(UInt8((cpu.pc & 0xFF00) >> 8), to: cpu.sp)
              return .continueExecution
            }
            if cycle == 2 {
              cpu.sp -= 1
              memory.write(UInt8(cpu.pc & 0x00FF), to: cpu.sp)
              return .continueExecution
            }
            if interrupt.contains(.vBlank) {
              interrupt.remove(.vBlank)
              cpu.pc = 0x0040
            } else if interrupt.contains(.lcdStat) {
              interrupt.remove(.lcdStat)
              cpu.pc = 0x0048
            } else if interrupt.contains(.timer) {
              interrupt.remove(.timer)
              cpu.pc = 0x0050
            } else if interrupt.contains(.serial) {
              interrupt.remove(.serial)
              cpu.pc = 0x0058
            } else if interrupt.contains(.joypad) {
              interrupt.remove(.joypad)
              cpu.pc = 0x0060
            }
            memory.write(interrupt.rawValue, to: LR35902.interruptFlagAddress)
            cpu.ime = false
            return .fetchNext
          },
          sourceLocation: sourceLocation
        )
      } else {
        self.loaded = LoadedInstruction(spec: spec,
                                        microcode: InstructionSet.microcodes[spec]!,
                                        sourceLocation: sourceLocation)
      }
    }

    var loaded: LoadedInstruction? = nil
    var cycle: Int = 0

    public func sourceAddressAndBank() -> (address: LR35902.Address, bank: Gameboy.Cartridge.Bank)? {
      guard case let .cartridge(sourceLocation) = loaded?.sourceLocation else {
        return nil
      }
      return Gameboy.Cartridge.addressAndBank(from: sourceLocation)
    }
  }

  // MARK: 8-bit registers
  public var a: UInt8 = 0x01
  public var b: UInt8 = 0x00
  public var c: UInt8 = 0x13
  public var d: UInt8 = 0x00
  public var e: UInt8 = 0xD8
  public var h: UInt8 = 0x01
  public var l: UInt8 = 0x4D

  /**
   The zero flag (Z).

   This flag is set when the result of a math operation is zero or two values match when using the CP instruction.
   */
  public var fzero: Bool = true

  /**
   The subtract flag (N).

   This flag is set if a subtraction was performed in the last math instruction.
   */
  public var fsubtract: Bool = false

  /**
   The half-carry flag flag (H).

   This flag is set if a carry occurred from the lower nibble in the last math operation.
   */
  public var fhalfcarry: Bool = true

  /**
   The carry flag (C).

   This flag is set if a carry occurred from the last math operation or if register A is the smaller value when
   executing the CP instruction.
   */
  public var fcarry: Bool = true

  /** Flag register. */
  public var f: UInt8 {
    get {
      return
        (fzero        ? 0b1000_0000 : 0)
        | (fsubtract  ? 0b0100_0000 : 0)
        | (fhalfcarry ? 0b0010_0000 : 0)
        | (fcarry     ? 0b0001_0000 : 0)
    }
    set {
      fzero       = newValue & 0b1000_0000 != 0
      fsubtract   = newValue & 0b0100_0000 != 0
      fhalfcarry  = newValue & 0b0010_0000 != 0
      fcarry      = newValue & 0b0001_0000 != 0
    }
  }

  /**
   The interrupt master enable flag (IME).

   When false, all interrupts are disabled.
   When true, interrupts are enabled conditionally on the IE register.
   */
  public var ime: Bool = false

  /** Enabled bits represent a requested interrupt. */
  var interruptEnable: LR35902.Instruction.Interrupt = []

  /** Enabled bits represent a requested interrupt. */
  public var interruptFlag: LR35902.Instruction.Interrupt = []

  /**
   The halt status.

   When true, the CPU will stop executing instructions until the next interrupt occurs.
   */
  public var halted: Bool = false

  /** Indicates whether the CPU is fetching and executing instructions. */
  public var isRunning: Bool {
    return !halted
  }

  /**
   If greater than zero, then this value will be decremented on each machine cycle until it is less then or equal to 0,
   at which point ime will be enabled.
   */
  var imeScheduledCyclesRemaining: Int = 0

  // MARK: 16-bit registers
  // Note that, though these registers are ultimately backed by the underlying 8 bit registers, each 16-bit register
  // also stores the state value that was directly assigned to it.
  public var af: UInt16 {
    get { return UInt16(a) << 8 | UInt16(f) }
    set {
      a = UInt8(newValue >> 8)
      f = UInt8(newValue & 0x00FF)
    }
  }
  public var bc: UInt16 {
    get { return UInt16(b) << 8 | UInt16(c) }
    set {
      b = UInt8(newValue >> 8)
      c = UInt8(newValue & 0x00FF)
    }
  }
  public var de: UInt16 {
    get { return UInt16(d) << 8 | UInt16(e) }
    set {
      d = UInt8(newValue >> 8)
      e = UInt8(newValue & 0x00FF)
    }
  }
  public var hl: UInt16 {
    get { return UInt16(h) << 8 | UInt16(l) }
    set {
      h = UInt8(newValue >> 8)
      l = UInt8(newValue & 0x00FF)
    }
  }

  /** Stack pointer. */
  public var sp: UInt16 = 0xFFFE

  /** Program counter. */
  public var pc: Address = 0x0000

  /** The machine instruction represents the CPU's understanding of its current instruction. */
  public var machineInstruction = MachineInstruction()

  /** Trace information for a given register. */
  public var registerTraces: [LR35902.Instruction.Numeric: RegisterTrace] = [:]

  var nextAction: MachineInstruction.MicroCodeResult = .fetchNext

  /** Initializes the state with boot values. */
  public init() {}

  internal init(a: UInt8 = 0x01, b: UInt8 = 0x00, c: UInt8 = 0x13, d: UInt8 = 0x00, e: UInt8 = 0xD8, h: UInt8 = 0x01, l: UInt8 = 0x4D, fzero: Bool = true, fsubtract: Bool = false, fhalfcarry: Bool = true, fcarry: Bool = true, ime: Bool = false, interruptEnable: LR35902.Instruction.Interrupt = [], interruptFlag: LR35902.Instruction.Interrupt = [], halted: Bool = false, imeScheduledCyclesRemaining: Int = 0, sp: UInt16 = 0xFFFE, pc: LR35902.Address = 0x0000, machineInstruction: LR35902.MachineInstruction = MachineInstruction(), registerTraces: [LR35902.Instruction.Numeric : LR35902.RegisterTrace] = [:], nextAction: LR35902.MachineInstruction.MicroCodeResult = .fetchNext) {
    self.a = a
    self.b = b
    self.c = c
    self.d = d
    self.e = e
    self.h = h
    self.l = l
    self.fzero = fzero
    self.fsubtract = fsubtract
    self.fhalfcarry = fhalfcarry
    self.fcarry = fcarry
    self.ime = ime
    self.interruptEnable = interruptEnable
    self.interruptFlag = interruptFlag
    self.halted = halted
    self.imeScheduledCyclesRemaining = imeScheduledCyclesRemaining
    self.sp = sp
    self.pc = pc
    self.machineInstruction = machineInstruction
    self.registerTraces = registerTraces
    self.nextAction = nextAction
  }

  public static func zeroed() -> LR35902 {
    return LR35902(a: 0, b: 0, c: 0, d: 0, e: 0, h: 0, l: 0, fzero: false, fsubtract: false, fhalfcarry: false, fcarry: false, sp: 0, pc: 0, registerTraces: [:])
  }

  public func copy() -> LR35902 {
    return LR35902(a: a, b: b, c: c, d: d, e: e, h: h, l: l, fzero: fzero, fsubtract: fsubtract, fhalfcarry: fhalfcarry, fcarry: fcarry, ime: ime, interruptEnable: interruptEnable, interruptFlag: interruptFlag, halted: halted, imeScheduledCyclesRemaining: imeScheduledCyclesRemaining, sp: sp, pc: pc, machineInstruction: machineInstruction, registerTraces: registerTraces, nextAction: nextAction)
  }
}

// MARK: - Subscript access

extension LR35902 {
  // MARK: Subscript access of instructions using LR35902 instruction specifications
  /** 8-bit register subscript. */
  public subscript(numeric: LR35902.Instruction.Numeric) -> UInt8 {
    get { return get(numeric8: numeric) }
    set { set(numeric8: numeric, to: newValue) }
  }
  /** 16-bit register subscript. */
  public subscript(numeric: LR35902.Instruction.Numeric) -> UInt16 {
    get { return get(numeric16: numeric) }
    set { set(numeric16: numeric, to: newValue) }
  }

  public func get(numeric8: LR35902.Instruction.Numeric) -> UInt8 {
    switch numeric8 {
    case .a: return a
    case .b: return b
    case .c: return c
    case .d: return d
    case .e: return e
    case .h: return h
    case .l: return l
    default:
      preconditionFailure()
    }
  }
  public func set(numeric8: LR35902.Instruction.Numeric, to newValue: UInt8) {
    switch numeric8 {
    case .a: a = newValue
    case .b: b = newValue
    case .c: c = newValue
    case .d: d = newValue
    case .e: e = newValue
    case .h: h = newValue
    case .l: l = newValue
    default:
      preconditionFailure()
    }
  }

  public func get(numeric16: LR35902.Instruction.Numeric) -> UInt16 {
    switch numeric16 {
    case .af:           return af
    case .bc, .bcaddr:  return bc
    case .de, .deaddr:  return de
    case .hl, .hladdr:  return hl
    case .sp:           return sp
    default:
      preconditionFailure()
    }
  }
  public func set(numeric16: LR35902.Instruction.Numeric, to newValue: UInt16) {
    switch numeric16 {
    case .af:           af = newValue
    case .bc, .bcaddr:  bc = newValue
    case .de, .deaddr:  de = newValue
    case .hl, .hladdr:  hl = newValue
    case .sp:           sp = newValue
    default:
      preconditionFailure()
    }
  }

  /** Resets the register state. */
  public func clear(_ numeric: LR35902.Instruction.Numeric) {
    switch numeric {
    case .a:  a = 0
    case .b:  b = 0
    case .c:  c = 0
    case .d:  d = 0
    case .e:  e = 0
    case .h:  h = 0
    case .l:  l = 0
    case .bc: bc = 0
    case .de: de = 0
    case .hl: hl = 0
    case .sp: sp = 0
    default:
      preconditionFailure()
    }
    registerTraces.removeValue(forKey: numeric)
  }
}

extension LR35902 {
  /** Trace information for a specific register. */
  public struct RegisterTrace: Equatable {
    public init(sourceLocation: Disassembler.SourceLocation) {
      self.sourceLocation = sourceLocation
      self.loadAddress = nil
    }
    public init(loadAddress: LR35902.Address) {
      self.sourceLocation = nil
      self.loadAddress = loadAddress
    }
    public init(sourceLocation: Disassembler.SourceLocation, loadAddress: LR35902.Address) {
      self.sourceLocation = sourceLocation
      self.loadAddress = loadAddress
    }

    /** The address from which the value was loaded, if known. */
    public let loadAddress: LR35902.Address?

    /** The source location from which this register's value was loaded, if known. */
    public let sourceLocation: Disassembler.SourceLocation?
  }
}

extension LR35902: AddressableMemory {
  static let interruptEnableAddress: LR35902.Address = 0xFFFF
  static let interruptFlagAddress: LR35902.Address = 0xFF0F

  public func read(from address: Address) -> UInt8 {
    switch address {
    case LR35902.interruptEnableAddress: return interruptEnable.rawValue
    case LR35902.interruptFlagAddress:   return interruptFlag.rawValue
    default: fatalError()
    }
  }

  public func write(_ byte: UInt8, to address: Address) {
    switch address {
    case LR35902.interruptEnableAddress: interruptEnable = LR35902.Instruction.Interrupt(rawValue: byte)
    case LR35902.interruptFlagAddress:   interruptFlag = LR35902.Instruction.Interrupt(rawValue: byte)
    default: fatalError()
    }
  }

  public func sourceLocation(from address: Address) -> Disassembler.SourceLocation {
    return .memory(address)
  }
}
