import UIKit
import RxSwift
import RxCocoa

class BasicTransformerViewController: UIViewController {
	let disposeBag = DisposeBag()
	var viewModel: BasicTransformerViewModel
	private let inputText: PublishSubject<BasicTransformerViewIntent> = .init()

	//MARK: Views
	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.alignment = .fill
		stack.distribution = .fill
		return stack
	}()

	lazy var numberInputLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont.CustomStyle.digitFont
		return label
	}()

	lazy var outputText: UILabel = {
		let label = UILabel()
		label.text = "____"
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = UIFont.CustomStyle.personNameFont
		return label
	}()

	let keypad = DigitKeypad(keyNames: ["0","1","2","3","4","5","6","7","8","9"])

	let backspaceKey: UIButton = {
		let button = UIButton()
		button.setTitle("<X>", for: .normal)
		button.backgroundColor = UIColor.CustomStyle.keypadKey
		return button
	}()

	init(viewModel: BasicTransformerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)

	}

	//MARK: Init
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.CustomStyle.numberTransformerBackground
		setUpRx()
		setUpViews()
    }
	
	private func setUpRx() {
		keypad.output.subscribe(onNext: { output in
			switch output {
			case .pressedKey(number: let keyNumber):
				self.viewModel.processIntent(intent: .inputText("\(keyNumber)"))
			}
		}).disposed(by: disposeBag)

		viewModel.viewState.subscribe(onNext: { viewState in
			self.process(viewState: viewState)
		}).disposed(by: disposeBag)
	}

	private func setUpViews(){
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		mainStack.addArrangedSubview(outputText)
		mainStack.addArrangedSubview(numberInputLabel)
		mainStack.addArrangedSubview(keypad)
		keypad.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true
		keypad.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.3).isActive = true


		mainStack.addArrangedSubview(backspaceKey)
		backspaceKey.addTarget(self, action: #selector(pressedBackspace), for: .touchUpInside)
	}

	//MARK: Internal
	@objc private func pressedBackspace(){
		viewModel.processIntent(intent: .pressedBackspace)
	}

	private func process(viewState: BasicTransformerViewState) {
		outputText.text = viewState.phraseText
		numberInputLabel.text = viewState.digitsText
	}
}
