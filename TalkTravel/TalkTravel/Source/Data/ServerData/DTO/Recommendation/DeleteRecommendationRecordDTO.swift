// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherDataModel = try? JSONDecoder().decode(WeatherDataModel.self, from: jsonData)

import Foundation

// MARK: - WeatherDataModel
struct DeleteRecommendationRecordDTO: Codable {
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
