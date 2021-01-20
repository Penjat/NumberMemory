import UIKit

class DigitTestViewController: UIViewController {
	var configuration: DigitTestConfiguration?
	let numberTransformer = NumberTransformer()
	var answer = ""
	var answerIndex = 0

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

	//MARK: Set-up

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .blue

		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

		mainStack.addArrangedSubview(phraseLabel)
		mainStack.addArrangedSubview(answerLabel)

		mainStack.addArrangedSubview(keyStack)
		keyStack.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.5).isActive = true

		generateNumber()
    }


	func generateNumber() {
		let numDigits = configuration?.numDigits ?? 4
		let minNumber = Int(pow(10.0, Double(numDigits)))
		let maxNumber = Int(minNumber*2 - 1)
		let number = Int.random(in: minNumber...maxNumber)
		let numberString = "\(number)".dropFirst(1)

		let numberPhrase = numberTransformer.transform(numberText: String(numberString)).string
		answer = "\(numberString)"
		phraseLabel.text = numberPhrase
		answerLabel.text = ""
	}

	@objc func pressedKey(sender: UIButton) {
		if "\(sender.tag)" == answer.dropFirst(answerIndex).prefix(1) {
			answerIndex += 1
			answerLabel.text = "\(answerLabel.text ?? "") \(sender.tag)"
			checkDone()
			// Correct
			return
		}
		// Incorrect
	}

	func checkDone(){
		if answerIndex == answer.count {
			print("done")
			answerIndex = 0
			generateNumber()
		}
	}
}
