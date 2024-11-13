import Foundation

// MARK: - WeatherDataModel
struct GetReadTravelSchedulesDTO: Codable {
    let travelSchedules: [ReadTravelSchedule]

    enum CodingKeys: String, CodingKey {
        case travelSchedules = "travel_schedules"
    }
}

// MARK: - TravelSchedule
struct ReadTravelSchedule: Codable {
    let tripName, startDate, endDate: String
    let id, userID: Int
    let createdAt, updatedAt: String
    let placesToVisit: [String]

    enum CodingKeys: String, CodingKey {
        case tripName = "trip_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case id
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case placesToVisit = "places_to_visit"
    }
}
