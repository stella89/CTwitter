import UIKit

class TWTRTweetExtendedBuilder {
	private var jsonArray = [Any]()
	
	init(jsonArray: [Any]) {
		self.jsonArray = jsonArray
	}
	
	func build() -> [TWTRTweetExtended] {
		let tweets = jsonArray.reduce(into: [TWTRTweetExtended]()) { (tweets, value) in
			if let v = value as? [AnyHashable : Any],  let tweetExtended = TWTRTweetExtended(jsonDictionary: v) {
				tweets.append(tweetExtended)
			}
		}

		return tweets
	}
}
