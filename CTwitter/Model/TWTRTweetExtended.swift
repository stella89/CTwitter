import UIKit
import TwitterKit

class TWTRTweetExtended: TWTRTweet {
	private var jsonDictionary: [AnyHashable : Any]!
	var latitude: Double?
	var longitude: Double?
	
	required init?(jsonDictionary dictionary: [AnyHashable : Any]) {
		super.init(jsonDictionary: dictionary)
		self.jsonDictionary = dictionary
		extractCoordinate()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	private func extractCoordinate() {
		if let coordinates = jsonDictionary["coordinates"] as? [AnyHashable: Any],
			let coordinate = coordinates["coordinates"] as? [Double] {
				latitude = coordinate.last
				longitude = coordinate.first
		}
	}
}
