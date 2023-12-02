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
}
