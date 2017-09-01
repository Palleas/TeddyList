import Foundation

struct Task {
    let title: String
    let done: Bool
}

struct List {
    let tasks: [Task]
}

final class Parser {

    func parse(_ source: String) throws -> [List] {
        return []
    }
}

extension Task: AutoEquatable {}
extension List: AutoEquatable {}

