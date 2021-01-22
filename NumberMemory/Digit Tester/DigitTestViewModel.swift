import RxSwift

enum DigitTestViewIntent {
	case startTest
	case enterNumber(Int)
}

enum DigitTestViewResult {
	case correct
	case incorrect
}

struct DigitTestViewState {
	static func initialState() -> DigitTestViewState {
		return DigitTestViewState()
	}
}

class DigitTestViewModel {
	private let intentSubject: PublishSubject<DigitTestViewIntent> = .init()
	private lazy var results: Observable<DigitTestViewResult> = { intentToResult(intents: intentSubject).share() } ()
	public lazy var viewState: Observable<DigitTestViewState> = {
		results.resultsToViewState()
	}()

	public func processIntent(intent:DigitTestViewIntent){
		intentSubject.onNext(intent)
	}

	private func intentToResult(intents: Observable<DigitTestViewIntent>) -> Observable<DigitTestViewResult> {
		return intents.flatMap { intent -> Observable<DigitTestViewResult> in
			switch intent {
			case .startTest:
//				let phrase = self.transformer.transform(numberText: text).string
				return Observable<DigitTestViewResult>.empty()
			case .enterNumber:
				return Observable<DigitTestViewResult>.empty()
			}
		}
	}
}

private extension Observable where Element == DigitTestViewResult {
	func resultsToViewState() -> Observable<DigitTestViewState> {
		let initialState = DigitTestViewState.initialState()

		return	scan(initialState) { prevState, result in
			switch result {

			case .correct:
				break
			case .incorrect:
				break
			}

			return DigitTestViewState()
		}
	}
}
