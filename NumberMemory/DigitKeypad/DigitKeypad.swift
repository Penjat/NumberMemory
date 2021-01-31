import UIKit
import RxSwift

enum DigitKeypadOutput {
	case pressedKey(number: Int)
}

class DigitKeypad: UIView {
	let output: PublishSubject<DigitKeypadOutput> = .init()

	override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(keyNames: [String]) {
        self.init(frame: CGRect.zero)
		self.setUpKeys(keyNames: keyNames)
    }

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented on purpose.")
	}

	func setUpKeys(keyNames: [String]) {
		let mainStack: UIStackView = {
			let stack = UIStackView()
			stack.axis = .vertical
			stack.distribution = .fillEqually
			stack.spacing = 16.0
			return stack
		}()

		addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true

		func createHorizontalStack() -> UIStackView {
			let horizontalStack = UIStackView()
			horizontalStack.axis = .horizontal
			horizontalStack.distribution = .fillEqually
			horizontalStack.alignment = .fill
			mainStack.addArrangedSubview(horizontalStack)
			horizontalStack.spacing = 16.0
			return horizontalStack
		}

		func createKeypadKey(number: Int, display: [String]) -> UIView {
			let button = UIButton()
			button.backgroundColor = UIColor.CustomStyle.keypadKey
			button.titleLabel?.font = UIFont.CustomStyle.keypad
			button.tag = number
			button.setTitle(display[number], for: .normal)
			button.addTarget(self, action: #selector(pressedKey), for: .touchUpInside)
			button.layer.cornerRadius = 8.0
			return button
		}

		let line1 = createHorizontalStack()
		line1.addArrangedSubview(createKeypadKey(number: 0, display: keyNames))
		line1.addArrangedSubview(UIView())
		line1.addArrangedSubview(UIView())

		let line2 = createHorizontalStack()
		line2.addArrangedSubview(createKeypadKey(number: 1, display: keyNames))
		line2.addArrangedSubview(createKeypadKey(number: 2, display: keyNames))
		line2.addArrangedSubview(createKeypadKey(number: 3, display: keyNames))

		let line3 = createHorizontalStack()
		line3.addArrangedSubview(createKeypadKey(number: 4, display: keyNames))
		line3.addArrangedSubview(createKeypadKey(number: 5, display: keyNames))
		line3.addArrangedSubview(createKeypadKey(number: 6, display: keyNames))

		let line4 = createHorizontalStack()
		line4.addArrangedSubview(createKeypadKey(number: 7, display: keyNames))
		line4.addArrangedSubview(createKeypadKey(number: 8, display: keyNames))
		line4.addArrangedSubview(createKeypadKey(number: 9, display: keyNames))
	}

	@objc func pressedKey(sender: UIButton) {
		output.onNext(.pressedKey(number: sender.tag))
		sender.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
		sender.backgroundColor = UIColor.CustomStyle.keypadKeyPressed
		UIView.animate(withDuration: 0.5, animations: {
			sender.transform = .identity
			sender.backgroundColor = UIColor.CustomStyle.keypadKey
		})
	}
}
