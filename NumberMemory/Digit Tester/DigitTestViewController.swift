import UIKit

class DigitTestViewController: UIViewController {
	let numberTransformer = NumberTransformer()
	var answer = ""
	var answerIndex = 0

	//MARK: Views

	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.alignment = .center
		return stack
	}()

	let phraseLabel: UILabel = {
		let label = UILabel()
		label.text = "this is a sample phrase"
		label.textColor = .white
		label.numberOfLines = 0
		return label
	}()

	let answerLabel: UITextField = {
		let label = UITextField()
		label.placeholder = "_ _ _ _"
		label.font = UIFont.boldSystemFont(ofSize: 18)
		label.textColor = .yellow
		label.keyboardType = .numberPad
		return label
	}()

	//MARK: Set-up

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .blue

		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

		mainStack.addArrangedSubview(phraseLabel)
		mainStack.addArrangedSubview(answerLabel)


		generateNumber()
    }

	override func viewDidAppear(_ animated: Bool) {
		answerLabel.delegate = self
		answerLabel.becomeFirstResponder()
	}

	func generateNumber() {
		let number = Int.random(in: 10000...19999)
		let numberString = "\(number)".dropFirst(1)

		let numberPhrase = numberTransformer.transform(numberText: String(numberString)).string
		answer = "\(numberString)"
		phraseLabel.text = numberPhrase
		answerLabel.text = ""
	}
}

extension DigitTestViewController: UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		print("editing")
		return true
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		print(string)
		if string == answer.dropFirst(answerIndex).prefix(1) {

			print("answer is \(answer.dropFirst(answerIndex).prefix(1)) correct")
			answerIndex += 1
			return !checkDone()
		}
		print("answer is \(answer.prefix(1)) incorrect")
		return false
	}

	func checkDone() -> Bool {
		if answerIndex == answer.count {
			print("done")
			answerIndex = 0
			generateNumber()
			return true
		}
		return false
	}
}
