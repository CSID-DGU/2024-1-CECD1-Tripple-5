import Foundation

// MARK: - WeatherDataModel
struct GetReadRecommendationRecordDTO: Codable {
    let recommendationName: String
    let id, userID, placeID: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case recommendationName = "recommendation_name"
        case id
        case userID = "user_id"
        case placeID = "place_id"
        case createdAt = "created_at"
    }
}
