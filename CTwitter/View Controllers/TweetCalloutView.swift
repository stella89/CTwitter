//
//  TweetCalloutView.swift
//  CTwitter
//
//  Created by Djivede on 2019-03-17.
//  Copyright © 2019 spectrumdt. All rights reserved.
//

import UIKit

class TweetCalloutView: UIView {
	@IBOutlet fileprivate weak var lblUsername: UILabel!
	@IBOutlet fileprivate weak var lblName: UILabel!
	@IBOutlet fileprivate weak var imgProfile: UIImageView!

	static func build() -> TweetCalloutView {
		return UINib(nibName: "TweetCalloutView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TweetCalloutView
	}

	func configure(name: String?, username: String?, profileUrl: String?) {
		lblName.text = name
		
		if let urlString = profileUrl,  let url = URL(string: urlString) {
			imgProfile.af_setImage(withURL: url)
		}
		
		if let uName = username {
			lblUsername.text = "@" + uName
		}
	}
}
