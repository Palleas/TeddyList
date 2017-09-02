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

    func testParseAComplexList() throws {
        let note = """
It's simple. We, uh, kill the Batman.

There is a prison in a more ancient part of the world. A pit where men are thrown to suffer and die. But sometimes a man rises from the darkness. Sometimes, the pit sends something back.

- Ketchup
+ A new hat for @mergesort
+ pants
- iPad pro

It's simple. We, uh, kill the Batman.

There is a prison in a more ancient part of the world. A pit where men are thrown to suffer and die. But sometimes a man rises from the darkness. Sometimes, the pit sends something back.
"""
        let p = Parser()
        let lists = try p.parse(note)
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

    func testParseMultipleLists() throws {
        let note = """
# List of people

## Good peoples

- Batman
+ Green Lantern
- Green Arrow
+ Flash

There is a prison in a more ancient part of the world. A pit where men are thrown to suffer and die. But sometimes a man rises from the darkness. Sometimes, the pit sends something back.

## Bad people

- Joker
+ Sinestro

It's simple. We, uh, kill the Batman.

There is a prison in a more ancient part of the world. A pit where men are thrown to suffer and die. But sometimes a man rises from the darkness. Sometimes, the pit sends something back.
"""
        let p = Parser()
        let lists = try p.parse(note)
        let expected = [
            List(tasks: [
                Task(title: "Batman", done: false),
                Task(title: "Green Lantern", done: true),
                Task(title: "Green Arrow", done: false),
                Task(title: "Flash", done: true)
            ]),
            List(tasks: [
                Task(title: "Joker", done: false),
                Task(title: "Sinestro", done: true)
            ])
        ]

        XCTAssertEqual(expected, lists)
    }
}
