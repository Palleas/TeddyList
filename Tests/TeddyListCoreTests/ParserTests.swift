import XCTest
@testable import TeddyListCore

class ParserTests: XCTestCase {

    func testParseASimpleList() throws {
        let groceries = """
- Ketchup
+ A new hat for @mergesort
+ pants
- iPad pro
"""
        let p = Parser()
        let lists = try p.parse(groceries)
        let expected = [
            List(tasks: [
                Task(title: "Ketchup", done: false),
                Task(title: "A new hat for @mergesort", done: true),
                Task(title: "pants", done: true),
                Task(title: "iPad pro", done: false)
            ])
        ]

        XCTAssertEqual(expected, lists)
    }
}
