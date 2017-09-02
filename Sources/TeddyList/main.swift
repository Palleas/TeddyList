import TeddyListCore
import Foundation

let argv = ProcessInfo.processInfo.arguments
let tool = CommandLineTool()

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
