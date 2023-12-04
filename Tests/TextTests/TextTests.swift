import XCTest
@testable import Text

final class TextTests: XCTestCase
{
    func testFilterNumericWithOperators() throws
    {
        let input: Text = "a1b2c3"
        let correct: Text = "123"

        let result = input ∩ ℤ
        XCTAssertEqual(result, correct)
    }

    func testFirstOperator() throws
    {
        let correct: Text = "a"
        let input: Text = "abcd"

        let first: Text = try ⟝input

        XCTAssertEqual(first, correct)
    }


//    func testFirstOperatorArray() throws
//    {
//        let correct: Int = 1
//        let input: [Int] = [1, 2, 3, 4]
//
//        let first: Int = try ⟝input
//
//        XCTAssertEqual(first, correct)
//    }
}
