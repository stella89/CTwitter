import UIKit
import Alamofire

class AbstractTwitterFacade {
	static func getUrl(target: String) -> String? {
		if let baseUrl = Settings.instance.stringForkey(key: SettingKey.twitterApiBaseUrl) {
			return baseUrl + target
		}
		
		return nil
	}
	
	static func getAuthorizationHeader() -> String {
		if let apiKey = Settings.instance.stringForkey(key: SettingKey.twitterApiKey), let secretKey = Settings.instance.stringForkey(key: SettingKey.twitterApiSecretKey) {
			let token = apiKey + ":" + secretKey
			
			return "Basic " + token.toBase64()
		}
		
		return ""
	}
	
	static func getHeaders() -> HTTPHeaders? {
		return ["Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
				"Authorization": getAuthorizationHeader()]
	}
	
	static func executePostRequest(target: String, parameters: [String: Any]?, handler: ((Any) -> ())?) {
		if let url = getUrl(target: target), let headers = getHeaders() {
			do {
				Alamofire.request(try url.asURL(), method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
					.responseJSON { (response) in
						handler?(response)
				}
			} catch {
				print("Hm, something is wrong here.")
			}
		}
	}
}
