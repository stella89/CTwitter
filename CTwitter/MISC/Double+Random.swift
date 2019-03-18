import UIKit

extension Double {
	public static var random: Double {
		return Double(arc4random()) / 0xFFFFFFFF
	}
	
	public static func random(min: Double, max: Double) -> Double {
		return Double.random * (max - min) + min
	}
}
