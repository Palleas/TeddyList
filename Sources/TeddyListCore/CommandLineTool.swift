import Foundation
import GRDB

public final class CommandLineTool {
    private let arguments: [String]

    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    public func run() throws {
        if let first = arguments.first, first == "--help" {
            help()
        } else {
            try printAllLists(arguments: Array(arguments.dropFirst()))
        }

    }

    func printAllLists(arguments: [String]) throws {
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

    func help() {
        let content = """
TeddyBear v0.1
==============

Parse your Bear notes and list the todolists.

Usage: teddylist <command> [<args>]

Run teddyList --help to print this message.
"""
        print(content)
    }
}
