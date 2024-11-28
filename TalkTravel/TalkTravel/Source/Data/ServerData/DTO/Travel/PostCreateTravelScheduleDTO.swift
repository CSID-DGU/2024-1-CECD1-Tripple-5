import Foundation

// MARK: - WeatherDataModel
struct PostCreateTravelScheduleDTO: Codable {
    let tripName, startDate, endDate: String
    let id, userID: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case tripName = "trip_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case id
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
