import Foundation
import XCTest
@testable import TeddyListCore

final class TeddyListTests: XCTestCase {

    func testListingListFromNotes() throws {
        let teddy = TeddyList(database: MockDatabase(), options: .defaults)
        let lists = try teddy.list()
        let expected = ("A note title", [
            List(tasks: [
                Task(title: "Batman", done: false),
                Task(title: "Green Lantern", done: true),
                Task(title: "Green Arrow", done: false),
                Task(title: "Flash", done: true),
                ])
            ])

        XCTAssertEqual(1, lists.count)
        XCTAssertEqual(expected.0, lists[0].0)
        XCTAssertEqual(expected.1, lists[0].1)

    }

    func testListingListFromNotesWithoutLists() throws {
        let teddy = TeddyList(database: DatabaseWithoutLists(), options: [.includeCompleted])
        let lists = try teddy.list()
        XCTAssertTrue(lists.isEmpty)
    }

    func testListingListFromNotesIncludingCompletedOnes() throws {
        let teddy = TeddyList(database: MockDatabase(), options: [.includeCompleted])
        let lists = try teddy.list()
        let expected = ("A note title", [
            List(tasks: [
                Task(title: "Batman", done: false),
                Task(title: "Green Lantern", done: true),
                Task(title: "Green Arrow", done: false),
                Task(title: "Flash", done: true),
            ]),
            List(tasks: [
                Task(title: "Joker", done: true),
                Task(title: "Sinestro", done: true)
            ])
        ])

        // Boooo
        XCTAssertEqual(1, lists.count)
        XCTAssertEqual(expected.0, lists[0].0)
        XCTAssertEqual(expected.1, lists[0].1)
    }

}

struct DatabaseWithoutLists: LocalDatabase {
    func findNotes() throws -> [Note] {
        return [
            Note(title: "A note without lists", content: ""),
            Note(title: "A second note without lists", content: ""),
            Note(title: "A 3rd note without lists", content: "")
        ]
    }
}

struct MockDatabase: LocalDatabase {

    func findNotes() -> [Note] {
        return [
            Note(title: "A note without lists", content: ""),
            Note(title: "A note title", content: """
# List of people

## Good peoples

- Batman
+ Green Lantern
- Green Arrow
+ Flash

There is a prison in a more ancient part of the world. A pit where men are thrown to suffer and die. But sometimes a man rises from the darkness. Sometimes, the pit sends something back.

## Bad people

+ Joker
+ Sinestro

It's simple. We, uh, kill the Batman.

There is a prison in a more ancient part of the world. A pit where men are thrown to suffer and die. But sometimes a man rises from the darkness. Sometimes, the pit sends something back.
"""),
        ]
    }
}
