import UIKit

class PIListViewController: UITableViewController {
	let transformer = NumberTransformer()
	var locations: Locations?
	var curArea: Int = 0

	var digitsTextField: UITextField?
	var locationTextField: UITextField?
	var areaNameTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(NumberLocationCell.self, forCellReuseIdentifier: "BlockCell")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddDigitsCell")
		title = "3.14..."
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Area", style: .plain, target: self, action: #selector(openAreaAlert))
		let userDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("NumberLocations").appendingPathExtension("plist")

		guard let data = try? Data(contentsOf: userDataURL) else {
			print("Error: Invalid Data")
			return
		}

		guard let locationData = try? PropertyListDecoder().decode(Locations.self, from: data) else {
			print("Error: Bad data format for property list")
			return
		}
		locations = locationData
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return locations?.areas.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let locations = locations else {
			return 0
		}

		if section == locations.areas.count - 1 {
			return locations.areas[section].locationNumberData.count + 1
		}

		return locations.areas[section].locationNumberData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section + 1 == (locations?.areas.count ?? 0) && indexPath.row >= (locations?.areas[indexPath.section].locationNumberData.count ?? 0) {
			let cell = tableView.dequeueReusableCell(withIdentifier: "AddDigitsCell", for: indexPath)
			cell.textLabel?.text = "Add Digits"
			cell.textLabel?.textAlignment = .center
			cell.backgroundColor = .orange
			return cell
		}
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlockCell", for: indexPath) as? NumberLocationCell, let location = locations?.areas[indexPath.section].locationNumberData[indexPath.row] else {
				return UITableViewCell()

		}
		cell.peopleLabel.attributedText = transformer.transform(numberText: location.digits)
		cell.digitLabel.text = location.digits
		cell.locationLabel.text = location.locationName

        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let locations = locations, indexPath.section + 1 == locations.areas.count, indexPath.row == locations.areas[indexPath.section].locationNumberData.count else {
			return
		}
		curArea = indexPath.section
		addDigits()
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let areaSectionView = UILabel()
		areaSectionView.backgroundColor = UIColor.green
		areaSectionView.textAlignment = .center
		areaSectionView.text = locations?.areas[section].name
		areaSectionView.font = .boldSystemFont(ofSize: 20)
		areaSectionView.heightAnchor.constraint(equalToConstant: 65).isActive = true

		return areaSectionView
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if var area = locations?.areas[indexPath.section] {
				area.locationNumberData.remove(at: indexPath.row)
				locations?.areas[indexPath.section] = area
				PListDataStore.saveLocationList(locationData: locations!)
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
		} else if editingStyle == .insert {

		}
	}

	/// MARK:

	public func addDigits(){
		let alert = UIAlertController(title: "Add Digits", message: "Message", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.default, handler: cancelAddDigits(alert:)))
		alert.addAction(UIAlertAction(title: "save", style: UIAlertAction.Style.default, handler: saveLocation(alert:)))
		alert.addAction(UIAlertAction(title: "save + next", style: UIAlertAction.Style.default, handler: saveDigitsAndNext(alert:)))
		alert.addTextField { (textField : UITextField!) -> Void in
			textField.placeholder = "Enter location"
			self.locationTextField = textField
			textField.becomeFirstResponder()
		}
		alert.addTextField { (textField : UITextField!) -> Void in
			textField.text = "4"
			textField.keyboardType = .numberPad
			self.digitsTextField = textField
		}
		present(alert, animated: true, completion: nil)
		locationTextField?.becomeFirstResponder()
	}

	public func saveLocation(alert: UIAlertAction) {
		guard let locationNumberData = locations?.areas.flatMap({$0.locationNumberData}), let numDigitString = digitsTextField?.text, let locationString = locationTextField?.text, let numDigits = Int(numDigitString) else {
			fatalError()
		}

		//Get the digits
		var index = 0
		for location in locationNumberData {
			index += location.digits.count
		}

		let digitString = String(piString.dropFirst(index).prefix(numDigits))

		let newLocation = LocationNumberData(digits: digitString, locationName: locationString)
		self.locations?.areas[curArea].locationNumberData.append(newLocation)
		PListDataStore.saveLocationList(locationData: locations!)
		tableView.reloadData()
	}

	public func cancelAddDigits(alert: UIAlertAction) {
		print("cancel not saving")
	}

	public func saveDigitsAndNext(alert: UIAlertAction) {
		saveLocation(alert: alert)
		addDigits()
		print("save and next")
	}

	@objc public func openAreaAlert() {

		let alert = UIAlertController(title: "Add Area", message: "Message", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.default, handler: nil))
		alert.addAction(UIAlertAction(title: "save", style: UIAlertAction.Style.default, handler: addArea(alert:)))
		alert.addTextField { (textField : UITextField!) -> Void in
			textField.placeholder = "Enter new area name"
			self.areaNameTextField = textField
			textField.becomeFirstResponder()
		}
		alert.addTextField { (textField : UITextField!) -> Void in
			textField.text = "4"
			textField.keyboardType = .numberPad
			self.digitsTextField = textField
		}
		present(alert, animated: true, completion: nil)
		locationTextField?.becomeFirstResponder()
	}

	@objc public func addArea(alert: UIAlertAction) {

		let newArea = LocationArea(name: self.areaNameTextField?.text ?? "new area" , locationNumberData: [])
		locations?.areas.append(newArea)
		PListDataStore.saveLocationList(locationData: locations!)
		tableView.reloadData()
	}
}
