import Foundation

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
