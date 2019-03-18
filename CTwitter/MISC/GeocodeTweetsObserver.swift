import UIKit
import TwitterKit

protocol GeocodeTweetsObserverDelegate {
	func willUpdateTweets(allTweets: [TWTRTweetExtended], tweetsToRemove: [TWTRTweetExtended], newTweets: [TWTRTweetExtended])
}

class GeocodeTweetsObserver: NSObject {
	static let instance = GeocodeTweetsObserver()
	let limit = 100
	let pollingFrequency = 20.0
	fileprivate var observers = [(GeocodeTweetsObserverDelegate & NSObject)]()
	fileprivate var geocodeData = (latitude: 0.0, longitude: 0.0, radius: "5km")
	fileprivate var geocodeSpecifier: String? {
		if !geocodeData.latitude.isZero && !geocodeData.longitude.isZero {
			return "\(geocodeData.latitude),\(geocodeData.longitude),\(geocodeData.radius)"
		}
		
		return nil
	}
	fileprivate var tweets = [TWTRTweetExtended]()
	fileprivate var timer: Timer?
	
	override init() {
		super.init()
		LocationManager.instance.addObserver(self)
	}
	
	deinit {
		LocationManager.instance.removeObserver(self)
		observers.removeAll()
	}
	
	func setRadius(radius: String) {
		stopObserving()
		geocodeData.radius = radius
		startObserving()
	}
	
	func startObserving() {
		if timer == nil {
			onPoll(_sender: self)
			timer = Timer.scheduledTimer(timeInterval: pollingFrequency, target: self, selector: #selector(onPoll(_sender:)), userInfo: nil, repeats: true)
			LocationManager.instance.startUpdating()
		}
	}
	
	func stopObserving() {
		if timer != nil {
			LocationManager.instance.startUpdating()
			timer?.invalidate()
			timer = nil
		}
	}
	
	func addObserver(_ observer: (GeocodeTweetsObserverDelegate & NSObject)) {
		observers.append(observer)
	}
	
	func removeObserver(_ observer: (GeocodeTweetsObserverDelegate & NSObject)) {
		if let idx = observers.firstIndex(where: { ( $0 === observer )}) {
			observers.remove(at: idx)
		}
	}
	
	@objc func onPoll(_sender: Any) {
		DispatchQueue.global(qos: .background).async { [weak self] in
			self?.callApi()
		}
	}
	
	func callApi() {
		let maxTweetId = self.tweets.map({ $0.tweetID}).max()
		
		TwitterApiFacade.searchTweets(geocodeSpecifier: geocodeSpecifier, sinceTweetId: maxTweetId, count: limit) { [weak self] (tweets) in
			let tweetsWithCoordinate = tweets?.filter({ $0.latitude != nil && $0.longitude != nil})
			
			DispatchQueue.global(qos: .background).async { [weak self] in
				self?.handleSearchResponse(tweets: tweetsWithCoordinate)
			}
		}
	}
	
	func handleSearchResponse(tweets: [TWTRTweetExtended]?) {
		if let newTweets = tweets {
			print(newTweets.map({ $0.tweetID}))
			print(self.tweets.map({ $0.tweetID}))
			guard newTweets.count > 0 else { return }
			let count = self.tweets.count
			var tweetsRemoved = [TWTRTweetExtended]()
			
			if count + newTweets.count < limit {
				self.tweets.append(contentsOf: newTweets)
			} else {
				let startIdx = max(0, (count - newTweets.count))
				
				tweetsRemoved = Array(self.tweets.suffix(newTweets.count))
				self.tweets.removeSubrange(startIdx..<count)
				self.tweets.append(contentsOf: newTweets)
			}
			
			DispatchQueue.main.async { [weak self] in
				if self?.tweets != nil {
					self?.observers.forEach({ $0.willUpdateTweets(allTweets: self!.tweets, tweetsToRemove: tweetsRemoved, newTweets: newTweets)})
				}
			}
		}
	}
}

extension GeocodeTweetsObserver: LocationManagerDelegate {
	func didChangeLocation(latitude: Double, longitude: Double) {
		stopObserving()
		geocodeData.latitude = latitude
		geocodeData.longitude = longitude
		startObserving()
	}
}
