import Foundation
import GRDB

struct Note {
    let title: String
    let content: String
}

extension Note: AutoEquatable {}

protocol LocalDatabase {
    func findNotes() throws -> [Note]
}

final class SQLiteDatabase: LocalDatabase {
    private let db: Database

    init(db: Database) {
        self.db = db
    }

    func findNotes() throws -> [Note] {
        let rows = try Row.fetchCursor(db, "SELECT ZTITLE, ZTEXT FROM ZSFNOTE WHERE ZTRASHED=0")
        return try Array(rows.map { Note(title: $0["ZTITLE"], content: $0["ZTEXT"]) })
    }
}

final class TeddyList {

    struct Options: OptionSet {
        let rawValue: Int

        /// Print all lists, including completed ones
        static let includeCompleted = Options(rawValue: 1 << 0)

        static let defaults: Options = []
    }

    private let options: Options
    private let database: LocalDatabase

    init(database: LocalDatabase, options: Options) {
        self.database = database
        self.options = options
    }

    func list() throws -> [(String, [List])] {

        let parser = Parser()

        let result = try database.findNotes()
            .map { note -> (String, [List]) in
                let lists = try parser.parse(note.content).filter { list in
                    let tasks = list.tasks.filter { options.contains(.includeCompleted) || !$0.done }
                    return tasks.count > 0
                }

                print("Number of lists = \(lists.count)")
                return (note.title, lists)
            }
            .flatMap { $0 }
            .filter { !$0.1.isEmpty }
        return result
    }
}

func ==(lhs: (String, [List]), rhs: (String, [List])) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}
