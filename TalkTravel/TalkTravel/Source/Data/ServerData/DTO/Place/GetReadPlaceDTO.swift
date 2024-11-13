struct GetReadPlaceDTO: Codable {
    let placeName: String
    let x, y: Int
    let roadAddressName, placeURL, placeDescription: String
    let placeCost, id: Int
    let createdAt: String
    let placesToVisit: [String]

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case x, y
        case roadAddressName = "road_address_name"
        case placeURL = "place_url"
        case placeDescription = "place_description"
        case placeCost = "place_cost"
        case id
        case createdAt = "created_at"
        case placesToVisit = "places_to_visit"
    }
}
