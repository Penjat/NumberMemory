import UIKit

class DigitTesterConfigViewController: UIViewController {
	enum Constants {
		static let StartingNumberDigits = 4
	}
	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.spacing = 20.0
		return stack
	}()

	let digitStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 20
		stack.distribution = .fill
		stack.alignment = .center
		return stack
	}()

	let startButton: UIButton = {
		let button = UIButton()
		button.setTitle("Start", for: .normal)
		button.addTarget(self, action: #selector(startTest), for: .touchUpInside)
		return button
	}()

	let feedbackSelect: UISegmentedControl = {
		let control = UISegmentedControl.init(items: ["None","Letters","Digits"])
		return control
	}()

	let keySelect: UISegmentedControl = {
		let control = UISegmentedControl.init(items: ["Numbers","Letters"])
		return control
	}()

	lazy var digitStepper: UIStepper = {
		let stepper = UIStepper()
		stepper.maximumValue = 4
		stepper.minimumValue = 1
		stepper.value = Double(Constants.StartingNumberDigits)

		stepper.addTarget(self, action: #selector(digitStepperValueChanged(_:)), for: .touchUpInside)
		return stepper
	}()

	let numberDigitsLabel: UILabel = {
		let label = UILabel()
		label.text = "Number of Digits: \(Constants.StartingNumberDigits)"
		return label
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .gray

		mainStack.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(mainStack)
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true


		mainStack.addArrangedSubview(digitStack)
		mainStack.addArrangedSubview(feedbackSelect)
		mainStack.addArrangedSubview(keySelect)

		digitStack.addArrangedSubview(digitStepper)
		digitStack.addArrangedSubview(numberDigitsLabel)
		mainStack.addArrangedSubview(startButton)
    }

	@objc public func startTest() {
		let keyDisplay: KeyDisplay = keySelect.selectedSegmentIndex == 0 ? .digits : .letters

		let feedbackType: Feedback = {
			switch feedbackSelect.selectedSegmentIndex {
			case 0:
				return .none
			case 1:
				return .letters
			case 2:
				return .digits
			default:
				return .none
			}
		}()

		let digitTest = DigitTest(numDigits: Int(digitStepper.value), keyDisplay: keyDisplay, feedback: feedbackType)
		let viewModel = DigitTestViewModel(digitTest: digitTest, transformer: NumberTransformer())
		let controller = DigitTestViewController(viewModel: viewModel)
		self.navigationController?.pushViewController(controller, animated: true)
	}

	@objc func digitStepperValueChanged(_ sender: UIStepper) {
		numberDigitsLabel.text = "Number of Digits: \(Int(sender.value))"
	}
}
