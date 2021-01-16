import UIKit

class BasicTransformerViewController: UIViewController {
	let transformer = NumberTransformer()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemPink

		setUpViews()
		numberInputField.becomeFirstResponder()
    }

	private func setUpViews(){
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		numberInputField.delegate = self
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

extension BasicTransformerViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let inputText = numberInputField.text {
			if let char = string.cString(using: String.Encoding.utf8) {
				let isBackSpace = strcmp(char, "\\b")
				if (isBackSpace == -92) {
					outputText.attributedText = transformer.transform(numberText: String(inputText.dropLast()))
				} else {
					outputText.attributedText = transformer.transform(numberText: inputText + String(string) )
				}
			}
		}
		  return true
	}
}
