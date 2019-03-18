//
//  HomeDetailViewModel.swift
//  CTwitter
//
//  Created by Djivede on 2019-03-17.
//  Copyright © 2019 spectrumdt. All rights reserved.
//

import UIKit
import TwitterKit

class HomeDetailViewModel: NSObject {
	fileprivate var tweet: TWTRTweet!
	var isRetweeted: Bool {
		return tweet.isRetweeted
	}
	
	init(tweet: TWTRTweetExtended) {
		super.init()
		self.tweet = tweet
	}
	
	func retweet() {
		TwitterApiFacade.retweet(tweetId: tweet.tweetID) { (success) in
			print("Twitter API error : Your credentials do not allow access to this resource")
			//if success refresh tweet
		}
	}
	
	func generateTweetView() -> TWTRTweetView {
		let tweetView = TWTRTweetView(tweet: tweet, style: TWTRTweetViewStyle.compact)
		
		tweetView.showActionButtons = true
		tweetView.theme = TWTRTweetViewTheme.light
		return tweetView
	}
}
