import RxSwift

enum BasicTransformerViewIntent {
	case inputText(String)
	case pressedBackspace
}

enum BasicTransformerViewResult {
	case showPhrase(String, String)
}

struct BasicTransformerViewState {
	let phraseText: String
	let digitsText: String

	static func initialState() -> BasicTransformerViewState {
		return BasicTransformerViewState(phraseText: "", digitsText: "")
	}
}

class BasicTransformerViewModel {
	private let intentSubject: PublishSubject<BasicTransformerViewIntent> = .init()
	private lazy var results: Observable<BasicTransformerViewResult> = { intentToResult(intents: intentSubject).share() } ()
	public lazy var viewState: Observable<BasicTransformerViewState> = { results.resultsToViewState()
		}()

	private let transformer = NumberTransformer()
	private var digits = ""

	private func intentToResult(intents: Observable<BasicTransformerViewIntent>) -> Observable<BasicTransformerViewResult> {
		return intents.flatMap { intent -> Observable<BasicTransformerViewResult> in
			switch intent {
			case .inputText(let newDigit):
				self.digits += newDigit
				let phrase = self.transformer.transform(numberText: self.digits).string
				return Observable<BasicTransformerViewResult>.just(.showPhrase(phrase, self.digits))
			case .pressedBackspace:
				self.digits = String(self.digits.dropLast())
				let phrase = self.transformer.transform(numberText: self.digits).string
				return Observable<BasicTransformerViewResult>.just(.showPhrase(phrase, self.digits))
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
			case .showPhrase(let phrase, let digits):
				return BasicTransformerViewState(phraseText: phrase, digitsText: digits)
			}
		}
	}
}
