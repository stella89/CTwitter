import Foundation

extension String {
    func substring(_ from: Int) -> String {
		let index = self.index(self.startIndex, offsetBy: from)
		
		return String(self[index...])
    }
}
