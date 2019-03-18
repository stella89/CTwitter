import UIKit

extension UIView {
	func addSubviewToFit(_ view: UIView) {
		let views = ["view": view]
		
		self.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
		                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
		                                                                metrics: nil,
		                                                                views: views))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
		                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
		                                                                metrics: nil,
		                                                                views: views))
	}
}
