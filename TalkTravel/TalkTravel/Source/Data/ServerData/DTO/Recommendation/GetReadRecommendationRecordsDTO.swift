import Foundation

struct GetReadRecommendationRecordsDTO: Codable {
    let recommendationRecords: [GetReadRecommendationRecord]

    enum CodingKeys: String, CodingKey {
        case recommendationRecords = "recommendation_records"
    }
}

// MARK: - RecommendationRecord
struct GetReadRecommendationRecord: Codable {
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
