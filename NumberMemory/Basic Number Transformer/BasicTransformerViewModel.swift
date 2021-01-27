import RxSwift

enum BasicTransformerViewIntent {
	case inputText(String)
}

enum BasicTransformerViewResult {
	case showPhrase(String)
}

struct BasicTransformerViewState {
	let phraseText: String

	static func initialState() -> BasicTransformerViewState {
		return BasicTransformerViewState(phraseText: "")
	}
}

class BasicTransformerViewModel {
	private let intentSubject: PublishSubject<BasicTransformerViewIntent> = .init()
	private lazy var results: Observable<BasicTransformerViewResult> = { intentToResult(intents: intentSubject).share() } ()
	public lazy var viewState: Observable<BasicTransformerViewState> = { results.resultsToViewState()
		}()

	private let transformer = NumberTransformer()

	private func intentToResult(intents: Observable<BasicTransformerViewIntent>) -> Observable<BasicTransformerViewResult> {
		return intents.flatMap { intent -> Observable<BasicTransformerViewResult> in
			switch intent {
			case .inputText(let text):
				let phrase = self.transformer.transform(numberText: text).string
				return Observable<BasicTransformerViewResult>.just(.showPhrase(phrase))
			}
		}
	}

	// MARK: Public Functions

	public func processIntent(intent:BasicTransformerViewIntent){
		intentSubject.onNext(intent)
	}
}

private extension Observable where Element == BasicTransformerViewResult {
	func resultsToViewState() -> Observable<BasicTransformerViewState> {
		let initialState = BasicTransformerViewState.initialState()

		return	scan(initialState) { prevState, result in
			switch result {
			case .showPhrase(let phrase):
				return BasicTransformerViewState(phraseText: phrase)
			}
		}
	}
}
