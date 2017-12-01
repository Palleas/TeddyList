import Foundation
import GRDB
import Utility

public final class CommandLineTool {
    private let arguments: [String]

    enum Output {
        case prettyText
        case json
    }

    public init(arguments: [String]) {
        self.arguments = arguments
    }

    public func run() throws {
        let parser = ArgumentParser(
            commandName: "tdl",
            usage: "[--json true]",
            overview: ""
        )

        let useJSON = parser.add(
            option: "--json",
            shortName: "-j",
            kind: Bool.self,
            usage: "Export notes as JSON",
            completion: nil
        )

        let displayCompleted = parser.add(
            option: "--all",
            shortName: "-a",
            kind: Bool.self,
            usage: "Include completed notes",
            completion: nil
        )

        let result = try parser.parse(arguments)

        var options = TeddyList.Options.defaults
        if case let .some(json) = result.get(useJSON), json {
            options.insert(.useJSON)
        }

        if case let .some(completed) = result.get(displayCompleted), completed {
            options.insert(.includeCompleted)
        }

        try printAllLists(option: options)
    }

    func printAllLists(option: TeddyList.Options) throws {
        let homeDirURL = URL(fileURLWithPath: NSHomeDirectory())
        let dbQueue = try DatabaseQueue(path: "\(homeDirURL.absoluteString)/Library/Containers/net.shinyfrog.bear/Data/Documents/Application Data/database.sqlite")
        try dbQueue.inDatabase { db in
            let options: TeddyList.Options
            if let first = arguments.first, first == "--all" {
                options = [.includeCompleted]
            } else {
                options = .defaults
            }

            let teddy = TeddyList(database: SQLiteDatabase(db: db), options:options)

            try teddy.list().forEach { (title, lists) in
                print(title)
                print(String(repeating: "=", count: title.characters.count))
                print()

                lists.flatMap { $0.tasks }.forEach { task in
                    let symbol = task.done ? "✅" : "🅾️"
                    print("\(symbol)  \(task.title)")
                }
                print()
            }
        }

    }

}
