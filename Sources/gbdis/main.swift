import Foundation
import LR35902

let romFilePath = "/Users/featherless/workbench/awakenlink/rom/LinksAwakening.gb"
let disassemblyPath = URL(fileURLWithPath: "/Users/featherless/workbench/gbdis/disassembly", isDirectory: true)

let data = try Data(contentsOf: URL(fileURLWithPath: romFilePath))

let cpu = LR35902(rom: data)

print("Performing recursive descent disassembly...")

cpu.disassemble(range: 0x0000..<0x0008, inBank: 0)
cpu.disassemble(range: 0x0008..<0x0010, inBank: 0)
cpu.disassemble(range: 0x0010..<0x0018, inBank: 0)
cpu.disassemble(range: 0x0018..<0x0020, inBank: 0)
cpu.disassemble(range: 0x0020..<0x0028, inBank: 0)
cpu.disassemble(range: 0x0028..<0x0030, inBank: 0)
cpu.disassemble(range: 0x0030..<0x0038, inBank: 0)
cpu.disassemble(range: 0x0038..<0x0040, inBank: 0)
cpu.disassemble(range: 0x0100..<0x4000, inBank: 0)

extension Array {
  fileprivate func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}

func write(_ string: String, fileHandle: FileHandle) {
  fileHandle.write("\(string)\n".data(using: .utf8)!)
}

func line(_ instruction: String, address: UInt16, bytes: Data? = nil, comment: String? = nil) -> String {
  let code = "    \(instruction)".padding(toLength: 48, withPad: " ", startingAt: 0)

  var parts = ["\(code) ; $\(address.hexString)"]

  if let bytes = bytes {
    parts.append(": ")
    parts.append(bytes.map { "$\($0.hexString)" }.joined(separator: " "))
  }

  if let comment = comment {
    parts.append(" ")
    parts.append(comment)
  }

  return parts.joined()
}

func line(_ transfersOfControl: Set<LR35902.Disassembly.TransferOfControl>, cpu: LR35902) -> String {
  let sources = transfersOfControl
    .sorted(by: { $0.sourceAddress < $1.sourceAddress })
    .map { "\($0.kind) @ $\($0.sourceAddress.hexString)" }
    .joined(separator: ", ")
  let label = "\(RGBDSAssembly.label(at: cpu.pc, in: cpu.bank)):".padding(toLength: 48, withPad: " ", startingAt: 0)
  return "\(label) ; Sources: \(sources)"
}

let fm = FileManager.default
try fm.createDirectory(at: disassemblyPath, withIntermediateDirectories: true, attributes: nil)

var instructionsToDecode = Int.max

for bank in UInt8(0)..<UInt8(cpu.numberOfBanks) {
  let asmUrl = disassemblyPath.appendingPathComponent("bank_\(bank.hexString).asm")
  if fm.fileExists(atPath: asmUrl.path) {
    try fm.removeItem(atPath: asmUrl.path)
  }
  fm.createFile(atPath: asmUrl.path, contents: Data(), attributes: nil)
  let fileHandle = try FileHandle(forWritingTo: asmUrl)

  print("Writing bank \(bank.hexString)")
  if bank == 0 {
    write("SECTION \"ROM Bank \(bank.hexString)\", ROM0[$\(bank.hexString)]", fileHandle: fileHandle)
  } else {
    write("SECTION \"ROM Bank \(bank.hexString)\", ROMX[$4000], BANK[$\(bank.hexString)]", fileHandle: fileHandle)
  }
  write("", fileHandle: fileHandle)

  cpu.pc = (bank == 0) ? 0x0000 : 0x4000
  cpu.bank = bank
  let end: UInt16 = (bank == 0) ? 0x4000 : 0x8000
  var previousInstruction: LR35902.Instruction? = nil
  while cpu.pc < end {
    if let transfersOfControl = cpu.disassembly.transfersOfControl(at: cpu.pc, in: bank) {
      write(line(transfersOfControl, cpu: cpu), fileHandle: fileHandle)
    }

    if instructionsToDecode > 0,
      let instruction = cpu.disassembly.instruction(at: cpu.pc, in: bank) {
      instructionsToDecode -= 1
      if case .ld(.immediate16address, .a) = instruction.spec {
        if (0x2000..<0x4000).contains(instruction.immediate16!),
          let previousInstruction = previousInstruction,
          case .ld(.a, .immediate8) = previousInstruction.spec {
          cpu.bank = previousInstruction.immediate8!
        }
      }

      let index = LR35902.romAddress(for: cpu.pc, in: cpu.bank)
      let bytes = cpu[index..<(index + UInt32(instruction.width))]
      write(line(RGBDSAssembly.assembly(for: instruction, with: cpu), address: cpu.pc, bytes: bytes), fileHandle: fileHandle)

      cpu.pc += instruction.width

      switch instruction.spec {
      case .jp, .jr:
        write("", fileHandle: fileHandle)
        previousInstruction = nil
        cpu.bank = bank
      case .ret, .reti:
        write("", fileHandle: fileHandle)
        write("", fileHandle: fileHandle)
        previousInstruction = nil
        cpu.bank = bank
      default:
        previousInstruction = instruction
      }

    } else {
      previousInstruction = nil
      cpu.bank = bank

      var accumulator: [UInt8] = []
      let initialPc = cpu.pc
      repeat {
        accumulator.append(cpu[cpu.pc, cpu.bank])
        cpu.pc += 1
      } while cpu.pc < end
        && (instructionsToDecode == 0 || cpu.disassembly.instruction(at: cpu.pc, in: bank) == nil)
        && cpu.disassembly.transfersOfControl(at: cpu.pc, in: bank) == nil

      var lineBlock = initialPc
      for blocks in accumulator.chunked(into: 8) {
        let instruction = RGBDSAssembly.assembly(for: blocks)
        let displayableBytes = blocks.map { ($0 >= 32 && $0 <= 126) ? $0 : 46 }
        let bytesAsCharacters = String(bytes: displayableBytes, encoding: .ascii) ?? ""
        write(line(instruction, address: lineBlock, comment: "|\(bytesAsCharacters)|"), fileHandle: fileHandle)
        lineBlock += UInt16(blocks.count)
      }
      write("", fileHandle: fileHandle)
    }
  }
}

print("code \(Float(cpu.disassembly.code.count) * 100 / Float(data.count))%")
