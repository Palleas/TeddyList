//
//  Printer.swift
//  TeddyListPackageDescription
//
//  Created by Romain Pouclet on 2017-12-01.
//

import Foundation

protocol Printer {
    func printAll(notes: [ParsedNote]) throws
}

struct PrettyTextPrinter: Printer {
    func printAll(notes: [ParsedNote]) throws {
        notes.forEach { parsedNote in
            print(parsedNote.title)
            print(String(repeating: "=", count: parsedNote.title.characters.count))
            print()

            parsedNote.lists.flatMap { $0.tasks }.forEach { task in
                let symbol = task.done ? "✅" : "🅾️"
                print("\(symbol)  \(task.title)")
            }
            print()
        }

    }
}
struct JSONPrinter: Printer {

    func printAll(notes: [ParsedNote]) throws {
        let encoder = JSONEncoder()
        let content = try encoder.encode(notes)
        if let payload = String(data: content, encoding: .utf8) {
            print("\(payload)")
        }
    }
}
