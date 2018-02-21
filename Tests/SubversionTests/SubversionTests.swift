import XCTest
@testable import Subversion

class SubversionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(Subversion().text, "Hello, World!")
        XCTAssertEqual("Hello World", "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
