import Foundation
import RxSwift

enum DigitTestViewIntent {
	case startTest
	case enterNumber(Int)
}

enum DigitTestViewResult {
	case askQuestion(DigitTestQuestion)
	case correct
	case incorrect
}

struct DigitTestViewState {
	let questionText: String
	static func initialState() -> DigitTestViewState {
		return DigitTestViewState(questionText: "")
	}
}

class DigitTestViewModel {
	private let intentSubject: PublishSubject<DigitTestViewIntent> = .init()
	private lazy var results: Observable<DigitTestViewResult> = { intentToResult(intents: intentSubject, questions: questions).share() } ()
	public lazy var viewState: Observable<DigitTestViewState> = {
		results.resultsToViewState()
	}()

	private let digitTest: DigitTest
	public let questions: PublishSubject<DigitTestQuestion> = .init()
	private let numberTransformer: NumberTransformer

	init(digitTest: DigitTest, transformer: NumberTransformer) {
		self.digitTest = digitTest
		self.numberTransformer = transformer
		
	}

	public func processIntent(intent:DigitTestViewIntent){
		intentSubject.onNext(intent)
	}

	private func intentToResult(intents: Observable<DigitTestViewIntent>, questions: Observable<DigitTestQuestion>) -> Observable<DigitTestViewResult> {
		return intents.flatMap { intent -> Observable<DigitTestViewResult> in
			switch intent {
			case .startTest:
				print("Starting Test.")
				let question = DigitTestQuestion(answer: [], phrase: "hi")
				self.questions.onNext(question)
				return Observable<DigitTestViewResult>.just(.askQuestion(question))
			case .enterNumber(let number):
				print("entered number: \(number)")
				let result = self.checkQuestion()

				return result
			}
		}
	}

	private func checkQuestion() -> Observable<DigitTestViewResult>{
		print("checking...")
		return questions.takeLast(1).flatMap {_ -> Observable<DigitTestViewResult> in
			print("this was called")
			return Observable<DigitTestViewResult>.just(.correct) }


	}
}

private extension Observable where Element == DigitTestViewResult {
	func resultsToViewState() -> Observable<DigitTestViewState> {
		let initialState = DigitTestViewState.initialState()

		return	scan(initialState) { prevState, result in
			switch result {

			case .correct:
				return DigitTestViewState(questionText: "correct")
				break
			case .incorrect:
				break
			case .askQuestion(let question):
				return DigitTestViewState(questionText: question.phrase)
			}

			return DigitTestViewState(questionText: "")
		}
	}

	private func generateQuestion(numDigits: Int) -> DigitTestQuestion {
		var digits: [Int]

		return DigitTestQuestion(answer: [5], phrase: "this is a sample answer")
	}
}
