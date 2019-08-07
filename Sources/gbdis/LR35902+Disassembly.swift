import Foundation

extension LR35902 {
  class Disassembly {
    private var instructionMap: [UInt32: Instruction] = [:]
    private var jumpMap: [UInt32: JumpKind] = [:]

    var code = IndexSet()
    func isCode(at pc: UInt16, in bank: UInt8) -> Bool {
      let index = UInt32(pc) + UInt32(bank) * LR35902.bankSize
      return code.contains(Int(index))
    }

    func register(instruction: Instruction, at pc: UInt16, in bank: UInt8) {
      let index = UInt32(pc) + UInt32(bank) * LR35902.bankSize

      instructionMap[index] = instruction

      code.insert(integersIn: Int(index)..<(Int(index) + Int(instruction.width)))
    }
    func instruction(at pc: UInt16, in bank: UInt8) -> Instruction? {
      let index = UInt32(pc) + UInt32(bank) * LR35902.bankSize
      return instructionMap[index]
    }

    enum JumpKind {
      case relative
      case absolute
    }
    func register(jumpAddress pc: UInt16, in bank: UInt8, kind: JumpKind) {
      let index = UInt32(pc) + UInt32(bank) * LR35902.bankSize
      jumpMap[index] = kind
    }
    func jump(at pc: UInt16, in bank: UInt8) -> JumpKind? {
      let index = UInt32(pc) + UInt32(bank) * LR35902.bankSize
      return jumpMap[index]
    }
  }
}