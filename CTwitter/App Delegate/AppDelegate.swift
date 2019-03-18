//
//  AppDelegate.swift
//  CTwitter
//
//  Created by Djivede on 2019-03-16.
//  Copyright © 2019 spectrumdt. All rights reserved.
//

import UIKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		if let consumerKey = Settings.instance.stringForkey(SettingKey.twitterApiKey), let consumerSecret = Settings.instance.stringForkey(SettingKey.twitterApiSecretKey) {
			TWTRTwitter.sharedInstance().start(withConsumerKey: consumerKey, consumerSecret: consumerSecret)
		}
		
		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
	}
}

