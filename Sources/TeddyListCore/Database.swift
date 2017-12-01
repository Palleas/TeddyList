import Foundation
import GRDB

struct Note {
    let id: String
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
        let rows = try Row.fetchCursor(db, "SELECT ZUNIQUEIDENTIFIER, ZTITLE, ZTEXT FROM ZSFNOTE WHERE ZTRASHED=0")
        return try Array(rows.map { Note(id: $0["ZUNIQUEIDENTIFIER"], title: $0["ZTITLE"], content: $0["ZTEXT"]) })
    }
}
