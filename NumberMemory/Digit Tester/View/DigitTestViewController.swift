import UIKit
import RxSwift

class DigitTestViewController: UIViewController {
	enum Constants {
		static let feedBackFlashTime = 0.8
	}
	let disposeBag = DisposeBag()
	let viewModel: DigitTestViewModel

	//MARK: Init

	init(viewModel: DigitTestViewModel) {
		self.viewModel = viewModel
		keyStack = DigitKeypad(keyNames: viewModel.keyNames())
		super.init(nibName: nil, bundle: nil)

		viewModel.viewState.subscribe(onNext: { viewState in
			self.phraseLabel.text = viewState.questionText
			self.answerLabel.text =  viewState.correctDigits
			self.phraseLabel.alpha = 1
			self.answerLabel.alpha = 1
			self.phraseLabel.transform = .identity
			self.answerLabel.transform = .identity
		}).disposed(by: disposeBag)

		viewModel.viewEffects.subscribe(onNext: { viewEffect in
			self.process(effect: viewEffect)
		}).disposed(by: disposeBag)

		keyStack.output.subscribe(onNext: { output in
			self.processKeypad(output)
		}).disposed(by: disposeBag)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		setUpViews()
		viewModel.processIntent(intent: .startTest)
    }

	func setUpViews() {
		view.backgroundColor = .blue

		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

		mainStack.addArrangedSubview(phraseLabel)
		mainStack.addArrangedSubview(answerLabel)
		mainStack.addArrangedSubview(feedbackLabel)

		mainStack.addArrangedSubview(keyStack)
		keyStack.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.5).isActive = true

		mainStack.addSubview(feedbackFlashLabel)
		feedbackFlashLabel.translatesAutoresizingMaskIntoConstraints = false
		feedbackFlashLabel.topAnchor.constraint(equalTo: mainStack.topAnchor).isActive = true
		feedbackFlashLabel.bottomAnchor.constraint(equalTo: keyStack.topAnchor).isActive = true
		feedbackFlashLabel.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.6).isActive = true
		feedbackFlashLabel.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor).isActive = true
	}

	//MARK: Views

	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.alignment = .fill
		stack.distribution = .fill
		stack.spacing = 64.0
		return stack
	}()

	let keyStack: DigitKeypad

	let phraseLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()

	let answerLabel: UITextField = {
		let label = UITextField()
		label.placeholder = "_"
		label.font = UIFont.boldSystemFont(ofSize: 18)
		label.textColor = .yellow
		label.keyboardType = .numberPad
		label.textAlignment = .center
		return label
	}()

	let feedbackLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.textAlignment = .center
		label.font = UIFont.CustomStyle.feedbackFont
		label.textColor = .white
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	let feedbackFlashLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.CustomStyle.feedbackFlashLetter
		label.text = "O"
		label.alpha = 0
		label.textAlignment = .center
		label.baselineAdjustment = .alignCenters
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.01
		return label
	}()

	func process(effect: DigitTestViewEffect) {
		switch effect {
		case .showMessage(let message):
			feedbackLabel.alpha = 1
			feedbackLabel.transform = CGAffineTransform.init(translationX: 0.0, y: 40)
			UIView.animate(withDuration: 0.6, animations: {
				self.feedbackLabel.text = message
				self.feedbackLabel.alpha = 0
				self.feedbackLabel.transform = CGAffineTransform.init(translationX: 0.0, y: 0.0)
			})
		case .phraseComplete:
			UIView.animate(withDuration: 1.3, animations: {
				self.phraseLabel.transform = CGAffineTransform.init(translationX: 0, y: 30).scaledBy(x: 2.0, y: 2.0)
				self.phraseLabel.alpha = 0

				self.answerLabel.transform = CGAffineTransform.init(translationX: 0, y: -100).scaledBy(x: 2.4, y: 2.4)
				self.answerLabel.alpha = 0
			})
		case .showPhrase:
			phraseLabel.transform = CGAffineTransform.init(translationX: 0, y: 30).scaledBy(x: 2.0, y: 2.0)
			phraseLabel.alpha = 0

			answerLabel.transform = .identity
			answerLabel.alpha = 0

			UIView.animate(withDuration: 0.8, animations: {
				self.phraseLabel.transform = .identity
				self.phraseLabel.alpha = 1

				self.answerLabel.transform = CGAffineTransform.init(translationX: 0, y: -100).scaledBy(x: 2.4, y: 2.4)
				self.answerLabel.alpha = 0
			})
		case .flashFeedback(let feedback):
			view.backgroundColor = UIColor.CustomStyle.digitTesterFlash
			feedbackFlashLabel.alpha = 0.7
			feedbackFlashLabel.text = feedback
			feedbackFlashLabel.textColor = UIColor.CustomStyle.feedbackFlashStart

			UIView.animate(withDuration: Constants.feedBackFlashTime, animations: {
				self.view.backgroundColor = UIColor.CustomStyle.digitTesterBackground
				self.feedbackFlashLabel.alpha = 0.0
			})
		}
	}
	//MARK: Internal
	private func processKeypad(_ output: DigitKeypadOutput) {
		switch output {
		case .pressedKey(number: let number):
			viewModel.processIntent(intent: .enterNumber(number))
		}
	}
}
