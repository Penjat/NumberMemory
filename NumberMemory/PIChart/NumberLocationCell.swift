import UIKit

class NumberLocationCell: UITableViewCell {

	var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.spacing = 16.0

		return stack
	}()

	var vertStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 16.0
		return stack
	}()

	public lazy var peopleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()

	public lazy var locationLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .boldSystemFont(ofSize: 18)
		return label
	}()

	public lazy var digitLabel: UILabel = {
		let label = UILabel()
		label.lineBreakMode = .byCharWrapping
		label.numberOfLines = 0
		label.font = UIFont.CustomStyle.digitFont 
		label.widthAnchor.constraint(equalToConstant: 50).isActive = true
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubview(mainStack)

		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		mainStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		mainStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

		mainStack.addArrangedSubview(locationLabel)
		mainStack.addArrangedSubview(vertStack)
		vertStack.addArrangedSubview(digitLabel)
		vertStack.addArrangedSubview(peopleLabel)

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
