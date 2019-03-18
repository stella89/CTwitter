import UIKit
import Alamofire
import TwitterKit

class AlamofireFacade {
	static func getUrl(target: String) -> String? {
		if let baseUrl = Settings.instance.stringForkey(SettingKey.twitterApiBaseUrl) {
			return baseUrl + target
		}
		
		return nil
	}
	
	//github.com/mattdonnelly/Swifter
	static func authorizationHeader(for method: HTTPMethod, url: URL, parameters: [String: Any]) -> String {
		guard let accessToken = TWTRTwitter.sharedInstance().sessionStore.session()?.authToken, let consumerKey = Settings.instance.stringForkey(SettingKey.twitterApiKey) else {
			return ""
		}
		var authorizationParameters = [String: Any]()
		authorizationParameters["oauth_version"] = "1.0"
		authorizationParameters["oauth_signature_method"] = "HMAC-SHA1"
		authorizationParameters["oauth_consumer_key"] = consumerKey
		authorizationParameters["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))
		authorizationParameters["oauth_nonce"] = UUID().uuidString
		
		authorizationParameters["oauth_token"] = accessToken
		
		for (key, value) in parameters where key.hasPrefix("oauth_") {
			authorizationParameters.updateValue(value, forKey: key)
		}
		
		let combinedParameters = authorizationParameters +| parameters
		
		let finalParameters = combinedParameters
		
		authorizationParameters["oauth_signature"] = self.oauthSignature(for: method, url: url, parameters: finalParameters)
		
		let authorizationParameterComponents = authorizationParameters.urlEncodedQueryString(using: String.Encoding.utf8).components(separatedBy: "&").sorted()
		
		var headerComponents = [String]()
		for component in authorizationParameterComponents {
			let subcomponent = component.components(separatedBy: "=")
			if subcomponent.count == 2 {
				headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
			}
		}
		
		return "OAuth " + headerComponents.joined(separator: ", ")
	}
	
	static func oauthSignature(for method: HTTPMethod, url: URL, parameters: [String: Any]) -> String {
		guard let consumerSecret = Settings.instance.stringForkey(SettingKey.twitterApiSecretKey) else {
			return ""
		}
		let tokenSecret = TWTRTwitter.sharedInstance().sessionStore.session()?.authTokenSecret.urlEncodedString() ?? ""
		let encodedConsumerSecret = consumerSecret.urlEncodedString()
		let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
		let parameterComponents = parameters.urlEncodedQueryString(using: String.Encoding.utf8).components(separatedBy: "&").sorted()
		let parameterString = parameterComponents.joined(separator: "&")
		let encodedParameterString = parameterString.urlEncodedString()
		let encodedURL = url.absoluteString.urlEncodedString()
		let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
		
		let key = signingKey.data(using: .utf8)!
		let msg = signatureBaseString.data(using: .utf8)!
		let sha1 = HMAC.sha1(key: key, message: msg)!
		return sha1.base64EncodedString(options: [])
	}
	
	static func executeGetRequest(target: String, parameters: [String: Any]?, handler: ((Data?) -> ())?) {
		if let urlStr = getUrl(target: target) {
			do {
				let url = try urlStr.asURL()
				let headers = ["Authorization": authorizationHeader(for: .get, url: url, parameters: (parameters ?? ["" : ""]))]
				Alamofire.request(url, method: HTTPMethod.get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
					.responseJSON { (response) in
						handler?(response.data)
				}
			} catch {
				print("Hm, something is wrong here.")
			}
		}
	}
	
	static func executePostRequest(target: String, parameters: [String: Any]?, handler: ((Data?) -> ())?) {
		if let urlStr = getUrl(target: target) {
			do {
				let url = try urlStr.asURL()
				let headers = ["Authorization": authorizationHeader(for: .post, url: url, parameters: (parameters ?? ["" : ""]))]
				Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
					.responseJSON { (response) in
						handler?(response.data)
				}
			} catch {
				print("Hm, something is wrong here.")
			}
		}
	}
}
