import Foundation

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

                return (note.title, lists)
            }
            .flatMap { $0 }
            .filter { !$0.1.isEmpty }
        return result
    }
}
