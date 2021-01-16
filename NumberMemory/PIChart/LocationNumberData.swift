import Foundation

struct Locations: Codable {
	var areas: [LocationArea]
}

public struct LocationArea: Codable {
	var name: String
	var locationNumberData: [LocationNumberData]
}

struct LocationNumberData: Codable {
	let digits: String
	let locationName: String
}
