import TeddyListCore
import Foundation

let cli = CommandLineTool(arguments: Array(CommandLine.arguments.dropFirst()))
try! cli.run()
