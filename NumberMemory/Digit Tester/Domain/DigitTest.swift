import Foundation

enum KeyDisplay {
	case letters, digits
	var keyValues: [String] {
		switch self {
		case .digits:
			return ["1,2,3,4,5,6,7,8,9,0"]
		case .letters:
			return ["A","B","C","D","E","S","L","T","N","O"]
		}
	}
}

enum Feedback {
	case none, letters, digits
}

struct DigitTest {
	let numDigits: Int
	let keyDisplay: KeyDisplay
	let feedback: Feedback
}
