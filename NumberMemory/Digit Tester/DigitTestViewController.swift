import UIKit

class DigitTestViewController: UIViewController {
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

	let keyStack: UIView = {
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
					let button = UIButton()
					button.backgroundColor = .red
					let numberString = "\(0)"
					button.tag = 0
					button.setTitle(numberString, for: .normal)
					button.addTarget(self, action: #selector(pressedKey), for: .touchUpInside)
					button.layer.cornerRadius = 8.0
					horizontalStack.addArrangedSubview(button)
				} else {
					let button = UIButton()
					button.backgroundColor = .red
					let numberString = "\(index+1)"
					button.tag = index+1
					button.setTitle(numberString, for: .normal)
					button.addTarget(self, action: #selector(pressedKey), for: .touchUpInside)
					button.layer.cornerRadius = 8.0
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
		let number = Int.random(in: 10000...19999)
		let numberString = "\(number)".dropFirst(1)

		let numberPhrase = numberTransformer.transform(numberText: String(numberString)).string
		answer = "\(numberString)"
		phraseLabel.text = numberPhrase
		answerLabel.text = ""
	}

	@objc func pressedKey(sender: UIButton) {
		if "\(sender.tag)" == answer.dropFirst(answerIndex).prefix(1) {

			print("answer is \(answer.dropFirst(answerIndex).prefix(1)) correct")
			answerIndex += 1
			answerLabel.text = "\(answerLabel.text ?? "") \(sender.tag)"
			checkDone()
		}
		print("answer is \(answer.prefix(1)) incorrect")
	}

	func checkDone(){
		if answerIndex == answer.count {
			print("done")
			answerIndex = 0
			generateNumber()
		}
	}
}
