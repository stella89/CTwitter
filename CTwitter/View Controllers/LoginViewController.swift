//
//  LoginViewController.swift
//  CTwitter
//
//  Created by Djivede on 2019-03-16.
//  Copyright © 2019 spectrumdt. All rights reserved.
import UIKit
import TwitterKit

class LoginViewController: UIViewController {
	private var isAutoLogin = false
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		isAutoLogin = TWTRTwitter.sharedInstance().sessionStore.session() != nil
		view.subviews.forEach({ $0.isHidden = isAutoLogin }) 
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if isAutoLogin {
			self.goToHomeController()
		}
	}
	
	@IBAction private func onSignIn(_ sender: UIButton) {
		TWTRTwitter.sharedInstance().logIn { [weak self] (session, error) in
			if error == nil {
				self?.goToHomeController()
			}
		}
	}
	
	@objc private func goToHomeController() {
		let tabbarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CTwitterTabBarController")
		
		present(tabbarController, animated: true, completion: nil)
	}
}

