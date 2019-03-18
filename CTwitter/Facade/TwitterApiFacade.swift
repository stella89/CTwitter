import UIKit
import TwitterKit

class TwitterApiFacade {
	static func searchTweetsWithAlamofire(geocodeSpecifier: String?, sinceTweetId: String? = nil, count: Int, handler: (([TWTRTweetExtended]?) -> ())?) {
		let params = { () -> [String : Any] in
			var dict = ["count": "\(count)",
				"include_entities": "true",
				"q": " -filter:retweets filter:safe",
				"tweet_mode": "extended",
				"result_type" : "mixed"] as [String : Any]
			
			if let g = geocodeSpecifier {
				dict["geocode"] = g
			}
			
			if let sinceId = sinceTweetId {
				dict["since_id"] = sinceId
			}
			
			return dict
		}()
		AlamofireFacade.executeGetRequest(target: "1.1/search/tweets.json", parameters: params) { (r) in
			if r == nil {
				print("Error")
			}  else {
				do {
					let json = try JSONSerialization.jsonObject(with: r!, options: []) as! [String: Any]
					print(json)
					if let statuses = json["statuses"] as? [Any] {
						handler?(TWTRTweetExtendedBuilder.init(jsonArray: statuses).build())
					}
				} catch _ {
					handler?(nil)
				}
			}
		}
	}
	
	static func searchTweets(geocodeSpecifier: String?, sinceTweetId: String? = nil, count: Int, handler: (([TWTRTweetExtended]?) -> ())?) {
		let client = TWTRAPIClient()
		let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
		let params = { () -> [String : Any] in
			var dict = ["count": "\(count)",
				"include_entities": "true",
				"q": " -filter:retweets filter:safe",
				"tweet_mode": "extended",
				"result_type" : "mixed"] as [String : Any]
			
			if let g = geocodeSpecifier {
				dict["geocode"] = g
			}
			
			if let sinceId = sinceTweetId {
				dict["since_id"] = sinceId
			}
			
			return dict
		}()
		var clientError : NSError?
		let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
		
		client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
			if let error = connectionError {
				print("Error: \(error.localizedDescription)")
			} else {
				do {
					let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
					
					if let statuses = json["statuses"] as? [Any] {
						handler?(TWTRTweetExtendedBuilder.init(jsonArray: statuses).build())
					}
				} catch _ {
					handler?(nil)
				}
			}
		}
	}
	
	static func retweet(tweetId: String, handler: ((Bool) -> ())?) {
		let client = TWTRAPIClient()
		
		let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
		var clientError : NSError?
		let request = client.urlRequest(withMethod: "POST", urlString: statusesShowEndpoint, parameters: nil, error: &clientError)
		
		client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
			if let error = connectionError {
				handler?(false)
				print("Error: \(error.localizedDescription)")
			} else {
				do {
					let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
					
					print(json)
				} catch _ {
					handler?(false)
				}
				handler?(true)
			}
		}
	}
}
