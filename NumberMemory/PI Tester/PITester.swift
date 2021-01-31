import Foundation

class PITester {
	let startingDigit: Int
	var position = 0
	private(set) var correctDigits: String

	var correctAnswers = 0
	private var hasLost = false

	init(startingDigit: Int) {
		self.startingDigit = startingDigit
		self.correctDigits = "3.14" + piString.prefix(startingDigit)
	}

	public func checkDigit(_ digit: String) -> Bool {
		return String(piString.dropFirst(position).prefix(1)) == digit
	}

	public func addCorrect(digit: String) -> String {
		correctDigits = correctDigits + digit
		if !hasLost {
			correctAnswers += 1
		}
		return correctDigits
	}

	public func incorrect() {
		hasLost = true
	}

	public func advancePosition() {
		position += 1
	}
}
