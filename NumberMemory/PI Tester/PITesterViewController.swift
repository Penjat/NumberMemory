import UIKit
import RxSwift

class PITesterViewController: UIViewController {
	enum Constants {
		static let currentDigitTitle = "digit #\n"
		static let numberIncorrectTitle = "incorrect\n"
		static let numberCorrectTitle = "correct\n"
	}
	let disposeBag = DisposeBag()
	let viewModel: PITesterViewModel

    //MARK: Views
	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.alignment = .leading
		stack.distribution = .equalCentering
		return stack
	}()

	let infoStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.distribution = .equalCentering
		return stack
	}()

	let correctDigitsLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.numberOfLines = 1
		label.font = UIFont.CustomStyle.piTester.correctStream
		label.lineBreakMode = .byTruncatingHead
		label.textAlignment = .right
		return label
	}()

	let numberCorrectDigitsLabel: UILabel = {
		let label = UILabel()
		label.text = "0"
		label.numberOfLines = 2
		label.font = UIFont.CustomStyle.piTester.info
		label.textColor = UIColor.CustomStyle.info
		label.textAlignment = .center
		return label
	}()

	let numberIncorrectDigitsLabel: UILabel = {
		let label = UILabel()
		label.text = "0"
		label.numberOfLines = 2
		label.font = UIFont.CustomStyle.piTester.info
		label.textColor = UIColor.CustomStyle.info
		label.textAlignment = .center
		return label
	}()

	let currecntDigitLabel: UILabel = {
		let label = UILabel()
		label.text = "0"
		label.numberOfLines = 2
		label.font = UIFont.CustomStyle.piTester.info
		label.textColor = UIColor.CustomStyle.info
		label.textAlignment = .center
		return label
	}()

	let flashDigitLabel: UILabel = {
		let label = UILabel()
		label.text = "HI"
		label.font = UIFont.CustomStyle.feedbackFlashLetter
		label.alpha = 0
		return label
	}()

	let keypad = DigitKeypad(keyNames: ["0","1","2","3","4","5","6","7","8","9"])

	//MARK: Init
	init(viewModel: PITesterViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented on purpose. NO STORYBOARDS.")
	}

    //MARK: Set Up
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpRx()
		setUpViews()
		viewModel.processIntent(intent: .startUp)
    }

	private func setUpRx() {
		viewModel.viewState.subscribe(onNext: { viewState in
			self.process(state: viewState)
		}).disposed(by: disposeBag)

		viewModel.viewEffects.subscribe(onNext: { viewEffect in
			self.process(effect: viewEffect)
		}).disposed(by: disposeBag)

		keypad.output.subscribe(onNext: { output in
			switch output {
			case .pressedKey(number: let number):
				self.viewModel.processIntent(intent: .enterDigit(number))
			}
		}).disposed(by: disposeBag)
	}

	private func setUpViews() {
		view.backgroundColor = .systemPink
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8.0).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true


		infoStack.addArrangedSubview(numberCorrectDigitsLabel)
		infoStack.addArrangedSubview(currecntDigitLabel)
		infoStack.addArrangedSubview(numberIncorrectDigitsLabel)
		mainStack.addArrangedSubview(infoStack)
		infoStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true

		mainStack.addArrangedSubview(correctDigitsLabel)
		correctDigitsLabel.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.5).isActive = true

		mainStack.addArrangedSubview(keypad)
		keypad.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true

		correctDigitsLabel.addSubview(flashDigitLabel)
		flashDigitLabel.translatesAutoresizingMaskIntoConstraints = false
		flashDigitLabel.centerXAnchor.constraint(equalTo: correctDigitsLabel.trailingAnchor).isActive = true
		flashDigitLabel.centerYAnchor.constraint(equalTo: correctDigitsLabel.centerYAnchor).isActive = true
	}

    //MARK: Processing
    private func process(state: PITesterViewState) {
		correctDigitsLabel.text = state.correctDigits
		numberCorrectDigitsLabel.text = Constants.numberCorrectTitle + "\(state.numberCorrectDigits)"
		currecntDigitLabel.text = Constants.currentDigitTitle + "\(state.currentDigit)"
		numberIncorrectDigitsLabel.text = Constants.numberIncorrectTitle + "\(state.numberIncorrect)"
	}

	private func process(effect: PITesterViewEffect) {
		switch effect {
		case .flashDigit(let digitString):
			flashDigitLabel.text = digitString
			flashDigitLabel.alpha = 1
			flashDigitLabel.transform = .identity
			UIView.animate(withDuration: 0.6, animations: {
				self.flashDigitLabel.alpha = 0
				self.flashDigitLabel.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
			})
		}
	}
    //MARK: Private
}
