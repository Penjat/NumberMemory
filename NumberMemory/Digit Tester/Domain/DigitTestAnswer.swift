import Foundation

struct DigitTesResponse {
	let givinDigit: Int
	let actualDigit: Int
	let questionNumber: Int

	var isCorrect: Bool {
		givinDigit == actualDigit
	}
}
