import Foundation
import RxSwift

//MARK: I/O
enum PITesterViewIntent {
	case enterDigit(Int)
}

enum PITesterViewResult {
	case correct(correctDigits: String, numberCorrectDigits: Int)
	case incorrect
}

enum PITesterViewEffect {

}

struct PITesterViewState {
	let correctDigits: String
	let numberCorrectDigits: Int
	static func initialState() -> PITesterViewState {
		return PITesterViewState(
			correctDigits: "",
			numberCorrectDigits: 0)
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
					let correctDigits = self.piTester.addCorrect(digit: "\(digit)")
					return Observable<PITesterViewResult>.just(
						.correct(
						correctDigits: correctDigits,
						numberCorrectDigits: correctDigits.count ))
				}
				return Observable<PITesterViewResult>.just(.incorrect)
			}
		}
	}
	//MARK: - Output
    private func resultsToViewEffect(results: Observable<PITesterViewResult>) -> Observable<PITesterViewEffect> {
		return  results.compactMap{result -> PITesterViewEffect? in
			return nil
		}
	}
}

private extension Observable where Element == PITesterViewResult {
	func resultsToViewState() -> Observable<PITesterViewState> {
		let initialState = PITesterViewState.initialState()
		return	scan(initialState) { prevState, result in
			switch result {
			case .correct(let correctDigits, let numberCorrectDigits):
				return
					PITesterViewState(
					correctDigits: correctDigits,
					numberCorrectDigits: numberCorrectDigits)
			case .incorrect:
				return prevState
			}
		}
	}
}
