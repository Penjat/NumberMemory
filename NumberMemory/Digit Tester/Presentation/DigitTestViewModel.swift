import Foundation
import RxSwift

enum DigitTestViewIntent {
	case startTest
	case enterNumber(Int)
}

enum DigitTestViewResult {
	case askQuestion(DigitTestQuestion)
	case correctDigit(Int)
	case correctPhrase
	case incorrect
}

enum DigitTestViewEffect {
	case showMessage(String)
	case phraseComplete
	case showPhrase
	case flashFeedback(String)
}

struct DigitTestViewState {
	let questionText: String
	let correctDigits: String
	static func initialState() -> DigitTestViewState {
		return DigitTestViewState(questionText: "", correctDigits: "")
	}
}

class DigitTestViewModel {
	private enum Constants {
		static let quesionDelay = 1300
	}
	private let intentSubject: PublishSubject<DigitTestViewIntent> = .init()
	private lazy var results: Observable<DigitTestViewResult> = { intentToResult(intents: intentSubject).share()} ()
	public lazy var viewState: Observable<DigitTestViewState> = {
		results.resultsToViewState()
	}()
	public lazy var viewEffects: Observable<DigitTestViewEffect> = {
		resultsToViewEffect(results: results)
	}()

	private let digitTest: DigitTest

	private var questions: [DigitTestQuestion] = []
	private var responses: [DigitTestResponse] = []

	private var expectingDigits: [Int] = []

	private let numberTransformer: NumberTransformer

	init(digitTest: DigitTest, transformer: NumberTransformer) {
		self.digitTest = digitTest
		self.numberTransformer = transformer
	}

	public func processIntent(intent:DigitTestViewIntent){
		intentSubject.onNext(intent)
	}

	private func intentToResult(intents: Observable<DigitTestViewIntent>) -> Observable<DigitTestViewResult> {
		return intents.flatMap { intent -> Observable<DigitTestViewResult> in
			switch intent {

			case .startTest:
				print("Starting Test.")
				let question = self.generateQuestion(numDigits: self.digitTest.numDigits)
				self.expectingDigits = question.answer.reversed()
				return Observable<DigitTestViewResult>.just(.askQuestion(question))

			case .enterNumber(let number):
				print("entered number: \(number)")
				guard let expecting = self.expectingDigits.last else {
					return Observable<DigitTestViewResult>.empty()
				}
				if number == expecting {
					self.expectingDigits.removeLast()
					if self.expectingDigits.isEmpty {
						let question = self.generateQuestion(numDigits: self.digitTest.numDigits)
						self.expectingDigits = question.answer.reversed()
						return Observable.from([Observable<DigitTestViewResult>.just(.correctDigit(expecting)), Observable<DigitTestViewResult>.just(.correctPhrase),Observable<DigitTestViewResult>.just(.askQuestion(question)).delay(.milliseconds(Constants.quesionDelay), scheduler: MainScheduler.instance)]).concat()
					}
					return Observable<DigitTestViewResult>.just(.correctDigit(expecting))
				}
				return Observable<DigitTestViewResult>.just(.incorrect)
			}
		}
	}

	private func generateQuestion(numDigits: Int) -> DigitTestQuestion {
		var digits: [Int] = []
		for _ in 0..<numDigits {
			digits.append(Int.random(in: 0...9))
		}

		return DigitTestQuestion(answer: digits, phrase: numberTransformer.transform(number: DigitNumber(digits: digits)).phraseString)
	}

	public func keyNames() -> [String] {
		return digitTest.keyDisplay.keyValues
	}

	func resultsToViewEffect(results: Observable<DigitTestViewResult>) -> Observable<DigitTestViewEffect> {
		return  results.map{result -> DigitTestViewEffect in
			switch result {

			case .correctDigit(let digit):
				return .flashFeedback(self.digitTest.keyDisplay.keyValues[digit])
			case .incorrect:
				return .showMessage("inncorrect")
			case .askQuestion:
				return .showPhrase
			case .correctPhrase:
				return .phraseComplete
			}
		}
	}
}

private extension Observable where Element == DigitTestViewResult {
	func resultsToViewState() -> Observable<DigitTestViewState> {
		let initialState = DigitTestViewState.initialState()

		return	scan(initialState) { prevState, result in
			switch result {

			case .correctDigit(let digit):
				return DigitTestViewState(
					questionText: prevState.questionText,
					correctDigits: prevState.correctDigits + "\(digit)")
			case .incorrect:
				print("incorrect")
				return prevState
			case .askQuestion(let question):
				return DigitTestViewState(
					questionText: question.phrase,
					correctDigits: "")
			case .correctPhrase:
				return prevState
			}
		}
	}
}
