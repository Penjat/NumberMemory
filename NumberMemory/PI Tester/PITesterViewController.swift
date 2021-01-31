import UIKit
import RxSwift

class PITesterViewController: UIViewController {
	enum Constants {

	}
	let disposeBag = DisposeBag()
	let viewModel: PITesterViewModel

    //MARK: Views
	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.alignment = .leading
		return stack
	}()

	let correctDigitsLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.font = UIFont.CustomStyle.piTester.correctStream
		label.lineBreakMode = .byTruncatingHead
		label.textAlignment = .right
		return label
	}()

	let numberCorrectDigitsLabel: UILabel = {
		let label = UILabel()
		label.text = "0"
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
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true


		mainStack.addArrangedSubview(numberCorrectDigitsLabel)

		mainStack.addArrangedSubview(correctDigitsLabel)
		correctDigitsLabel.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.5).isActive = true

		mainStack.addArrangedSubview(keypad)
		keypad.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true
	}

    //MARK: Processing
    private func process(state: PITesterViewState) {
		correctDigitsLabel.text = state.correctDigits
		numberCorrectDigitsLabel.text = "\(state.numberCorrectDigits)"
	}

	private func process(effect: PITesterViewEffect) {

	}
    //MARK: Private
}
