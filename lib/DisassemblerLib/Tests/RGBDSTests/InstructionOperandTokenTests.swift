import XCTest

@testable import RGBDS

class InstructionOperandTokenTests: XCTestCase {

  func testStringInitialization() {
    XCTAssertEqual(InstructionOperandToken(string: "foo"), .specific("foo"))
    XCTAssertEqual(InstructionOperandToken(string: "123"), .numeric)
    XCTAssertEqual(InstructionOperandToken(string: "$123"), .numeric)
    XCTAssertEqual(InstructionOperandToken(string: "%123"), .numeric)
    XCTAssertEqual(InstructionOperandToken(string: "`123"), .numeric)
    XCTAssertEqual(InstructionOperandToken(string: "[$abcd]"), .address)
    XCTAssertEqual(InstructionOperandToken(string: "[$ffcd]"), .ffaddress)
    XCTAssertEqual(InstructionOperandToken(string: "[$ff]"), .address)
    XCTAssertEqual(InstructionOperandToken(string: "sp+$ff"), .stackPointerOffset)
  }
}
