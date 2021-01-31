import UIKit

extension UIFont {
	class CustomStyle {
		static let personNameFont: UIFont = UIFont(name: "RobotoCondensed-Bold", size: 18.0)!
		static let personActionFont: UIFont = UIFont(name: "RobotoCondensed-Bold", size: 18.0)!
		static let objectFont: UIFont = UIFont(name: "RobotoCondensed-Bold", size: 18.0)!
		static let digitFont: UIFont = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
		static let sectionTitle: UIFont = UIFont(name: "Instruction", size: 18.0)!
		static let keypad: UIFont = UIFont(name: "Instruction-Bold", size: 22.0)!
		static let feedbackFont: UIFont = UIFont(name: "Instruction-Bold", size: 18.0)!
		static let feedbackFlashLetter: UIFont = UIFont(name: "RobotoCondensed-Bold", size: 500.0)!
		
		static let piTester = PITesterStyle(correctStream: UIFont.monospacedDigitSystemFont(ofSize: 45, weight: .bold),
											info: UIFont(name: "Instruction", size: 16.0)!)
	}

	struct PITesterStyle {
		let correctStream: UIFont
		let info: UIFont
	}
}
