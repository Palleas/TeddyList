import TeddyListCore
import Foundation

let argv = Array(ProcessInfo.processInfo.arguments.dropFirst())

let tool = CommandLineTool(arguments: argv)

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
