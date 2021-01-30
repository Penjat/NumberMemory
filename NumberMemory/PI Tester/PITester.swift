import Foundation

class PITester {
	let startingDigit: Int
	var position = 0
	private var correctDigits = ""

	init(startingDigit: Int) {
		self.startingDigit = startingDigit
	}

	public func checkDigit(_ digit: String) -> Bool {
		return String(piString.dropFirst(position).prefix(1)) == digit
	}

	public func addCorrect(digit: String) -> String {
		correctDigits = correctDigits + digit
		return correctDigits
	}
}
