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
        var lists = [List]()
        var tasks: [Task]?

        source.enumerateLines { (line, stop) in
            print("Current line \(line)")

            // trim the line
            let line = line.trimmingCharacters(in: .whitespaces)

            // This is a task
            if line.starts(with: "+") || line.starts(with: "-") {
                // Extract the content of the task
                let task = Task(
                    title: String(line[line.index(after: line.startIndex)..<line.endIndex]).trimmed,
                    done: line.characters.first == "+"
                )

                if tasks == nil {
                    tasks = []
                }

                tasks?.append(task)
            // This is not a task
            } else {
                // Do we have a list of tasks in progress?
                if let currentTasks = tasks {
                    lists.append(List(tasks: currentTasks))
                    tasks = nil
                }
            }
        }

        if let remainingTasks = tasks {
            lists.append(List(tasks: remainingTasks))
        }

        return lists
    }
}

extension Task: AutoEquatable {}
extension List: AutoEquatable {}

