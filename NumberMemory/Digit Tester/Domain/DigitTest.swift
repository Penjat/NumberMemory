import Foundation

enum KeyDisplay {
	case letters, digits
	var keyValues: [String] {
		switch self {
		case .digits:
			return ["0","1","2","3","4","5","6","7","8","9","0"]
		case .letters:
			return ["O","A","B","C","D","E","S","L","T","N"]
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
