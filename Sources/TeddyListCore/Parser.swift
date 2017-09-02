import Foundation
import os.log

struct Task {
    let title: String
    let done: Bool
}

struct List {
    let tasks: [Task]
}

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

final class Parser {

    func parse(_ source: String) throws -> [List] {
        var tasks = [Task]()
        source.enumerateLines { (line, stop) in
            print("Current line \(line)")

            // trim the line
            let line = line.trimmingCharacters(in: .whitespaces)
            if line.starts(with: "+") || line.starts(with: "-") {
                print("Current line is a task")
                let task = Task(
                    title: String(line[line.index(after: line.startIndex)..<line.endIndex]).trimmed,
                    done: line.characters.first == "+"
                )

                tasks.append(task)
            }
        }

        return [List(tasks: tasks)]
    }
}

extension Task: AutoEquatable {}
extension List: AutoEquatable {}

