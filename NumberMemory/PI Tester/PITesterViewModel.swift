import Foundation
import RxSwift

//MARK: I/O
enum PITesterViewIntent {
	case startUp
	case enterDigit(Int)
}

enum PITesterViewResult {
	case startUp(correctDigits: String, startingDigit: Int)
	case correct(correctDigits: String, numberCorrectDigits: Int, currentDigit: Int)
	case incorrect(numberIncorrect: Int)
}

enum PITesterViewEffect {
	case flashDigit(String)
}

struct PITesterViewState {
	let correctDigits: String
	let numberCorrectDigits: Int
	let currentDigit: Int
	let numberIncorrect: Int
	static func initialState() -> PITesterViewState {
		return PITesterViewState(
			correctDigits: "",
			numberCorrectDigits: 0,
			currentDigit: 0,
			numberIncorrect: 0)
	}
}

//MARK: View Model
class PITesterViewModel {
	private enum Constants {

	}
	private let intentSubject: PublishSubject<PITesterViewIntent> = .init()
	private lazy var results: Observable<PITesterViewResult> = { intentToResult(intents: intentSubject).share()} ()
	public lazy var viewState: Observable<PITesterViewState> = {
		results.resultsToViewState()
	}()
    public lazy var viewEffects: Observable<PITesterViewEffect> = {
		resultsToViewEffect(results: results)
	}()

	let piTester: PITester

	//MARK: - Init
	init(piTester: PITester) {
		self.piTester = piTester
	}
	//MARK: - Input
	public func processIntent(intent:PITesterViewIntent){
		intentSubject.onNext(intent)
	}
	//MARK: - Internal
	private func intentToResult(intents: Observable<PITesterViewIntent>) -> Observable<PITesterViewResult> {
		return intents.flatMap { intent -> Observable<PITesterViewResult> in
			switch intent {
			case .enterDigit(let digit):
				if self.piTester.checkDigit("\(digit)") {
					print("correct")
					self.piTester.advancePosition()
					let correctDigits = self.piTester.addCorrect(digit: "\(digit)")
					return Observable<PITesterViewResult>.just(
						.correct(
						correctDigits: correctDigits,
						numberCorrectDigits: self.piTester.correctAnswers,
						currentDigit: self.piTester.position))
				}
				self.piTester.addIncorrect()
				return Observable<PITesterViewResult>.just(.incorrect(numberIncorrect: self.piTester.numberIncorrectAnswers))
			case .startUp:
				return Observable<PITesterViewResult>.just(.startUp(correctDigits: self.piTester.correctDigits,
																	startingDigit: self.piTester.correctAnswers))
			}
		}
	}
	//MARK: - Output
    private func resultsToViewEffect(results: Observable<PITesterViewResult>) -> Observable<PITesterViewEffect> {
		return  results.compactMap{result -> PITesterViewEffect? in
			switch result {
			case .startUp( _, _):
				return nil
			case .correct(let correctDigits, _, _):
				return .flashDigit(String(correctDigits.suffix(1)))
			case .incorrect:
				return nil
			}
		}
	}
}

private extension Observable where Element == PITesterViewResult {
	func resultsToViewState() -> Observable<PITesterViewState> {
		let initialState = PITesterViewState.initialState()
		return	scan(initialState) { prevState, result in
			switch result {

			case .correct(let correctDigits, let numberCorrectDigits, let currentDigit):
				return
					PITesterViewState(
						correctDigits: correctDigits,
						numberCorrectDigits: numberCorrectDigits,
						currentDigit: currentDigit,
						numberIncorrect: prevState.numberIncorrect)

			case .incorrect(let numberIncorrect):
				return PITesterViewState(
					correctDigits: prevState.correctDigits,
					numberCorrectDigits: prevState.numberCorrectDigits,
					currentDigit: prevState.currentDigit,
				numberIncorrect: numberIncorrect)

			case .startUp(let correctDigits, let startingDigit):
				return
					PITesterViewState(
						correctDigits: correctDigits,
						numberCorrectDigits: 0,
						currentDigit: startingDigit,
						numberIncorrect: 0)
			}
		}
	}
}
