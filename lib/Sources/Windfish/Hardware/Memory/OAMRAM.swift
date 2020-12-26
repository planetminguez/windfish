import Foundation

/** Object Attribute Map addressable memory. */
public struct OAMRAM: AddressableMemory {
  static let startAddress: LR35902.Address = 0xFE00
  public let addressableRanges: [ClosedRange<LR35902.Address>] = [
    OAMRAM.startAddress...0xFE9C
  ]

  struct ObjectAttributeMap {
    var x: UInt8
    var y: UInt8
    var tile: UInt8
    var flags: UInt8
  }
  var oams: [ObjectAttributeMap] = (0..<40).map { _ -> ObjectAttributeMap in
    ObjectAttributeMap(x: 0, y: 0, tile: 0, flags: 0)
  }

  public func read(from address: LR35902.Address) -> UInt8 {
    let relativeOffset = (address - OAMRAM.startAddress)
    let oamIndex = relativeOffset / 4
    let oam = oams[Int(oamIndex)]
    switch relativeOffset % 4 {
    case 0: return oam.x
    case 1: return oam.y
    case 2: return oam.tile
    case 3: return oam.flags
    default: fatalError()
    }
  }

  public mutating func write(_ byte: UInt8, to address: LR35902.Address) {
    let relativeOffset = (address - OAMRAM.startAddress)
    let oamIndex = Int(relativeOffset / 4)
    var oam = oams[oamIndex]
    switch relativeOffset % 4 {
    case 0: oam.x = byte
    case 1: oam.y = byte
    case 2: oam.tile = byte
    case 3: oam.flags = byte
    default: fatalError()
    }
    oams[oamIndex] = oam
  }
}
