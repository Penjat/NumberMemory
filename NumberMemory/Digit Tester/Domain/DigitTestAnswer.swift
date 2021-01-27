import Foundation

struct DigitTestResponse {
	let givinDigit: Int
	let actualDigit: Int
	let questionNumber: Int

	var isCorrect: Bool {
		givinDigit == actualDigit
	}
}
