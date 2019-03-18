//
//  TWTRTweetExtended.swift
//  CTwitter
//
//  Created by Djivede on 2019-03-16.
//  Copyright © 2019 spectrumdt. All rights reserved.
//

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
		} else if let place = jsonDictionary["place"] as? [AnyHashable: Any],
			let boundingBox = place["bounding_box"] as? [AnyHashable: Any],
			let coordinates = boundingBox["coordinates"] as? [Any],
			let coordinate = coordinates.first as? [[Double]] {
			latitude = coordinate.first?.last
			longitude = coordinate.first?.first
		}
	}
}
