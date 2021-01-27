import UIKit
import RxSwift

class DigitTestViewController: UIViewController {
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
		return label
	}()

	private func createKeypadKey(_ number: Int) -> UIView {
		let button = UIButton()
		button.backgroundColor = UIColor.CustomStyle.keypadKey
		button.titleLabel?.font = UIFont.CustomStyle.keypad
		let numberString = "\(number)"
		button.tag = number
		button.setTitle(numberString, for: .normal)
		button.addTarget(self, action: #selector(pressedKey), for: .touchUpInside)
		button.layer.cornerRadius = 8.0
		return button
	}

	lazy var keyStack: UIView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fillEqually
		stack.spacing = 16.0
		for i in 0..<4 {
			let horizontalStack = UIStackView()
			horizontalStack.axis = .horizontal
			horizontalStack.distribution = .fillEqually
			horizontalStack.alignment = .fill
			stack.addArrangedSubview(horizontalStack)
			horizontalStack.spacing = 16.0

			for y in 0..<3 {
				let index = i*3 + y
				if index == 9 || index == 11 {
					horizontalStack.addArrangedSubview(UIView())
				} else if index == 10 {
					let button = createKeypadKey(0)
					horizontalStack.addArrangedSubview(button)
				} else {
					let button = createKeypadKey(index+1)
					horizontalStack.addArrangedSubview(button)
				}
			}
		}
		return stack
	}()


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


		}
	}
}
