import UIKit
import RxSwift
import RxCocoa

class BasicTransformerViewController: UIViewController {
	let disposeBag = DisposeBag()
	var viewModel: BasicTransformerViewModel
	private let inputText: PublishSubject<BasicTransformerViewIntent> = .init()

	init(viewModel: BasicTransformerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		viewModel.viewState.subscribe(onNext: { viewState in
			self.outputText.text = viewState.phraseText
		}).disposed(by: disposeBag)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemPink
		setUpViews()
		numberInputField.becomeFirstResponder()
		numberInputField.rx.controlEvent(.editingChanged).withLatestFrom(numberInputField.rx.text.orEmpty).subscribe(onNext: { text in
			self.viewModel.processIntent(intent: .inputText(text))
		}).disposed(by: disposeBag)
    }

	private func setUpViews(){
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		mainStack.addArrangedSubview(numberInputField)
		mainStack.addArrangedSubview(outputText)


	}

	lazy var outputText: UILabel = {
		let label = UILabel()
		label.text = ""
		label.numberOfLines = 0
		return label
	}()


	lazy var numberInputField: UITextField = {
		let textField = UITextField()
		textField.isUserInteractionEnabled = true
		textField.keyboardType = .numberPad
		textField.placeholder = "enter a number"
		return textField
	}()

	lazy var mainStack: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.alignment = .center
		return	stackView
	}()
}
