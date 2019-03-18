import UIKit

extension UIView {
	var safeAreaBottomInset: Int {
		if #available(iOS 11.0, *) {
			return Int(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
		} else {
			return 0
		}
	}
	
	func addSubViewToFit(view: UIView, showSafeAreaInsets: Bool = false) {
		let views = ["view": view]
		var verticalVisualFormat = "V:|-0-[view]-0-|"
		
		if showSafeAreaInsets {
			verticalVisualFormat = "V:|-0-[view]-\(safeAreaBottomInset)-|"
		}
		
		self.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
		                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
		                                                                metrics: nil,
		                                                                views: views))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat,
		                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
		                                                                metrics: nil,
		                                                                views: views))
	}
	
	func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: bounds,
		                        byRoundingCorners: corners,
		                        cornerRadii: CGSize(width: radius, height:  radius))
		let maskLayer = CAShapeLayer()
		
		maskLayer.path = path.cgPath
		layer.mask = maskLayer
	}
	
	func addShadow() {
		let shadowPath = UIBezierPath(rect: self.bounds)
		
		self.backgroundColor = UIColor.white
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.lightGray.cgColor
		self.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
		self.layer.shadowOpacity = 0.5
		self.layer.shadowPath = shadowPath.cgPath
	}
	
	func addTopShadow() {
		let shadowSize : CGFloat = 5.0
		let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
												   y: -shadowSize / 2,
												   width: self.frame.size.width + shadowSize,
												   height: 10))
		
		self.backgroundColor = UIColor.white
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.lightGray.cgColor
		self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		self.layer.shadowOpacity = 0.5
		self.layer.shadowPath = shadowPath.cgPath
	}
}
