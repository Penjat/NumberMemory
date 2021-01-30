import UIKit

enum MainMenuOption: Int, CaseIterable {
	case NUMBER_TRANSFORMER
	case PI_CHART
	case DIGIT_TESTER
	case PI_TESTER

	var titleText: String {
		switch self {
		case .NUMBER_TRANSFORMER:
			return "Number Transformer"
		case .PI_CHART:
			return "PI Chart"
		case .DIGIT_TESTER:
			return "Digit Tester"
		case .PI_TESTER:
			return "PI Tester"
		}
	}
}
class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
		createPListIfNeeded()
		for family in UIFont.familyNames.sorted() {
			let names = UIFont.fontNames(forFamilyName: family)
			print("Family: \(family) Font names: \(names)")
		}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return MainMenuOption.allCases.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
		cell.textLabel?.text = MainMenuOption(rawValue: indexPath.row)?.titleText
		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let mode = MainMenuOption(rawValue: indexPath.row) else {
			return
		}
		switch mode {
		case .NUMBER_TRANSFORMER:
			let viewModel = BasicTransformerViewModel()
			self.navigationController?.pushViewController(BasicTransformerViewController(viewModel: viewModel), animated: true)
		case .PI_CHART:
			self.navigationController?.pushViewController(PIListViewController(), animated: true)
		case .DIGIT_TESTER:
			self.navigationController?.pushViewController(DigitTesterConfigViewController(), animated: true)
		case .PI_TESTER:
			let viewModel = PITesterViewModel(piTester: PITester(startingDigit: 0))
			self.navigationController?.pushViewController(PITesterViewController(viewModel: viewModel), animated: true)
		}
	}

	func createPListIfNeeded() {
		print("Checking for location list...")
		let userDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("NumberLocations").appendingPathExtension("plist")
		if !FileManager.default.fileExists(atPath: userDataURL.path) {
			print("not found creating...")
			let locations = Locations(areas: [LocationArea(name: "test loc", locationNumberData: [])])
			PListDataStore.saveLocationList(locationData: locations )
			print("Loaction list created.")
			return
		}
		print("Location list found.")
	}
}
