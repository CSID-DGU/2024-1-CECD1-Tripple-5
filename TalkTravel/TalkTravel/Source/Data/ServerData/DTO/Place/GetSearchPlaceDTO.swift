import Foundation

struct GetSearchPlaceDTO: Codable {
    let places: [GetSearchPlacePlace]
}

// MARK: - Place
struct GetSearchPlacePlace: Codable {
    let placeName: String
    let x, y: Double
    let roadAddressName: String
    let placeURL: String
    let visitorCharacteristics, estimatedCost, estimatedDuration: String
    let imgURL: String?
    let id: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case x, y
        case roadAddressName = "road_address_name"
        case placeURL = "place_url"
        case visitorCharacteristics = "visitor_characteristics"
        case estimatedCost = "estimated_cost"
        case estimatedDuration = "estimated_duration"
        case imgURL = "img_url"
        case id
        case createdAt = "created_at"
    }
}
