import Foundation
import GRDB

public final class CommandLineTool {
    private let arguments: [String]

    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    public func run() throws {
        let homeDirURL = URL(fileURLWithPath: NSHomeDirectory())
        let dbQueue = try DatabaseQueue(path: "\(homeDirURL.absoluteString)/Library/Containers/net.shinyfrog.bear/Data/Documents/Application Data/database.sqlite")

        let parser = Parser()

        try dbQueue.inDatabase { db in
            let rows = try Row.fetchCursor(db, "SELECT ZTITLE, ZTEXT FROM ZSFNOTE WHERE ZTRASHED=0")
            while let row = try rows.next() {
                let title: String = row["ZTITLE"]
                let lists = try parser.parse(row["ZTEXT"])
                guard lists.count > 0 else { continue }

                print(title)
                print(String(repeating: "=", count: title.characters.count))

                lists.forEach { list in
                    list.tasks.forEach { task in
                        let symbol = task.done ? "✅" : "🅾️"
                        print("\(symbol)  \(task.title)")
                    }

                    print()
                }
            }
        }
    }
}
