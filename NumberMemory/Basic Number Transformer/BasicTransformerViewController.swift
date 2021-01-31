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
		stack.distribution = .fillEqually
		return stack
	}()

	lazy var numberInputField: UITextField = {
		let textField = UITextField()
		textField.isUserInteractionEnabled = true
		textField.keyboardType = .numberPad
		textField.placeholder = "enter a number"
		return textField
	}()

	lazy var outputText: UILabel = {
		let label = UILabel()
		label.text = "____"
		label.numberOfLines = 0
		return label
	}()

	let keypad = DigitKeypad(keyNames: ["0","1","2","3","4","5","6","7","8","9"])

	init(viewModel: BasicTransformerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		viewModel.viewState.subscribe(onNext: { viewState in
			self.outputText.text = viewState.phraseText
		}).disposed(by: disposeBag)
	}

	//MARK: Init
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemPink
		setUpViews()
		keypad.output.subscribe(onNext: { output in
			switch output {
			case .pressedKey(number: let keyNumber):
				self.viewModel.processIntent(intent: .inputText("\(keyNumber)"))
			}
			}).disposed(by: disposeBag)
    }

	private func setUpViews(){
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		mainStack.addArrangedSubview(numberInputField)
		mainStack.addArrangedSubview(outputText)
		mainStack.addArrangedSubview(keypad)
		keypad.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true
	}
}
