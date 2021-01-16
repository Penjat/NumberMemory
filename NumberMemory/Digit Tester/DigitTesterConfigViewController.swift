import UIKit

class DigitTesterConfigViewController: UIViewController {
	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		return stack
	}()

	let startButton: UIButton = {
		let button = UIButton()
		button.setTitle("Start", for: .normal)
		button.addTarget(self, action: #selector(startTest), for: .touchUpInside)
		return button
	}()

	lazy var digitStepper: UIStepper = {
		let stepper = UIStepper()
		stepper.maximumValue = 4
		stepper.minimumValue = 1
		stepper.value = 1
		stepper.backgroundColor = .red
		
		return stepper
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .gray

		mainStack.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(mainStack)
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true


		mainStack.addArrangedSubview(digitStepper)
		mainStack.addArrangedSubview(startButton)
    }

	@objc public func startTest() {
		self.navigationController?.pushViewController(DigitTestViewController(), animated: true)
	}
}
