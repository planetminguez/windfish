import Foundation
import CPU

extension LR35902 {
  // MARK: - Lazily computed lookup tables for instruction widths

  static var instructionWidths: [InstructionSpec: CPUInstructionWidth<UInt16>] = {
    return widths(for: instructionTable + instructionTableCB)
  }()
}