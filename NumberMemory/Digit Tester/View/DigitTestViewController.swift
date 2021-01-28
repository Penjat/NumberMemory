import UIKit
import RxSwift

class DigitTestViewController: UIViewController {
	enum Constants {
		static let feedBackFlashTime = 0.8
	}
	let disposeBag = DisposeBag()
	let viewModel: DigitTestViewModel
	
	var answer = ""
	var answerIndex = 0

	//MARK: Init

	init(viewModel: DigitTestViewModel) {
		self.viewModel = viewModel
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

		let keyStack = createKeyStack(keyNames: viewModel.keyNames())
		mainStack.addArrangedSubview(keyStack)
		keyStack.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.5).isActive = true
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
		return label
	}()

	func createKeyStack(keyNames: [String]) -> UIView {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fillEqually
		stack.spacing = 16.0

		func createHorizontalStack() -> UIStackView {
			let horizontalStack = UIStackView()
			horizontalStack.axis = .horizontal
			horizontalStack.distribution = .fillEqually
			horizontalStack.alignment = .fill
			stack.addArrangedSubview(horizontalStack)
			horizontalStack.spacing = 16.0
			return horizontalStack
		}

		func createKeypadKey(number: Int, display: [String]) -> UIView {
			let button = UIButton()
			button.backgroundColor = UIColor.CustomStyle.keypadKey
			button.titleLabel?.font = UIFont.CustomStyle.keypad
			button.tag = number
			button.setTitle(display[number], for: .normal)
			button.addTarget(self, action: #selector(pressedKey), for: .touchUpInside)
			button.layer.cornerRadius = 8.0
			return button
		}

		let line1 = createHorizontalStack()
		line1.addArrangedSubview(createKeypadKey(number: 0, display: keyNames))
		line1.addArrangedSubview(UIView())
		line1.addArrangedSubview(UIView())

		let line2 = createHorizontalStack()
		line2.addArrangedSubview(createKeypadKey(number: 1, display: keyNames))
		line2.addArrangedSubview(createKeypadKey(number: 2, display: keyNames))
		line2.addArrangedSubview(createKeypadKey(number: 3, display: keyNames))

		let line3 = createHorizontalStack()
		line3.addArrangedSubview(createKeypadKey(number: 4, display: keyNames))
		line3.addArrangedSubview(createKeypadKey(number: 5, display: keyNames))
		line3.addArrangedSubview(createKeypadKey(number: 6, display: keyNames))

		let line4 = createHorizontalStack()
		line4.addArrangedSubview(createKeypadKey(number: 7, display: keyNames))
		line4.addArrangedSubview(createKeypadKey(number: 8, display: keyNames))
		line4.addArrangedSubview(createKeypadKey(number: 9, display: keyNames))

		return stack
	}

	@objc func pressedKey(sender: UIButton) {
		viewModel.processIntent(intent: .enterNumber(sender.tag))
	}

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
		case .flashFeedback(_):
			view.backgroundColor = UIColor.CustomStyle.digitTesterFlash
			UIView.animate(withDuration: Constants.feedBackFlashTime, animations: {
				self.view.backgroundColor = UIColor.CustomStyle.digitTesterBackground
			})
		}
	}
}
