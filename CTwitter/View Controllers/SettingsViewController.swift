import UIKit
import TwitterKit

class SettingsViewController: UIViewController {
	@IBAction func onLogOut(_ sender: Any) {
		let store = TWTRTwitter.sharedInstance().sessionStore
		
		if let userID = store.session()?.userID {
			store.logOutUserID(userID)
			dismiss(animated: true, completion: nil)
		}
	}
}
