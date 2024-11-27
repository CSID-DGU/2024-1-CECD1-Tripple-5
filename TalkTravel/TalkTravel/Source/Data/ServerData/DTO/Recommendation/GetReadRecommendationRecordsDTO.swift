import Foundation

struct GetReadRecommendationRecordsDTO: Codable {
    let recommendationRecordsDetail: [GetReadRecommendationRecord]

    enum CodingKeys: String, CodingKey {
        case recommendationRecordsDetail = "recommendation_records_detail"
    }
}

// MARK: - RecommendationRecordsDetail
struct GetReadRecommendationRecord: Codable {
    let recommendationName: String
    let id, userID, placeID: Int
    let createdAt: String
    let place: Place

    enum CodingKeys: String, CodingKey {
        case recommendationName = "recommendation_name"
        case id
        case userID = "user_id"
        case placeID = "place_id"
        case createdAt = "created_at"
        case place
    }
}

// MARK: - Place
struct Place: Codable {
    let placeName: String
    let x, y: Double
    let roadAddressName: String
    let placeURL: String
    let imgURL: String?
    let id: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case x, y
        case roadAddressName = "road_address_name"
        case placeURL = "place_url"
        case imgURL = "img_url"
        case id
        case createdAt = "created_at"
    }
}
