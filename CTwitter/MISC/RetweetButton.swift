import UIKit

class RetweetButton: UIButton {
	var isRetweeted: Bool = false {
		didSet {
			let color = isRetweeted ? UIColor.cGreen : UIColor.cLightGray
			
			tintColor = color
			titleLabel?.textColor = color
		}
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let nextState = !isRetweeted
		
		super.touchesBegan(touches, with: event)
		isRetweeted = nextState
	}
}
