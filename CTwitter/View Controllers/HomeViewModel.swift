//
//  HomeViewModel.swift
//  CTwitter
//
//  Created by Djivede on 2019-03-16.
//  Copyright © 2019 spectrumdt. All rights reserved.
//

import UIKit
import TwitterKit

protocol ViewModelDelegate: class {
	func didEndLoading()
	func reloadData()
}

class HomeViewModel: NSObject {
	private let client = TWTRAPIClient.withCurrentUser()
	private var currentCursor: TWTRTimelineCursor?

	override init() {
		super.init()
	}
	
	func search(geocodeSpecifier: String) {
		let dataSource = TWTRSearchTimelineDataSource(searchQuery: "", apiClient: client)
		//TWTRTweet
		dataSource.geocodeSpecifier = geocodeSpecifier
		dataSource.loadPreviousTweets(beforePosition: nil) { (tweets, currentCursor, error) in
			
		}
	}
}
