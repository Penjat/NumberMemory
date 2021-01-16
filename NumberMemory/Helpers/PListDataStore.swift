import Foundation

public class PListDataStore {
	static func saveLocationList(locationData: Locations) {
		let encoder = PropertyListEncoder()
		encoder.outputFormat = .xml

		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		do {
			let data = try encoder.encode(locationData)
			try data.write(to: documentsDirectory.appendingPathComponent("NumberLocations").appendingPathExtension("plist"))
		} catch {
			print(error)
		}
	}
}
