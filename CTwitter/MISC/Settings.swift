import UIKit

class Settings: NSObject {
	static let instance = Settings()
	private var prefs = UserDefaults.standard
	
	override init() {
		super.init()
		registerDefaults()
	}
	
	func stringForkey(_ key: String) -> String? {
		return prefs.string(forKey: key)
	}
	
	private func registerDefaults() {
		if let file = Bundle.main.path(forResource: "Settings", ofType: "plist"),
		let defaults = NSDictionary(contentsOfFile: file) as? [String: Any] {
			prefs.register(defaults: defaults)
		}
	}
}
