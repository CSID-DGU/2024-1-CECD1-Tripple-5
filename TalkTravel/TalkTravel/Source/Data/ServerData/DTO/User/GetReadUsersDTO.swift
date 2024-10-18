// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct GetReadUsesrDTO: Codable {
    let users: [ReadUsers]
}

// MARK: - User
struct ReadUsers: Codable {
    let accommodationBudget, foodBudget, sightseeingBudget: Int
    let travelTheme: String
    let id: Int
    let createdAt, updatedAt: String
    let recommendationRecords, chatRooms, travelSchedules: [String]

    enum CodingKeys: String, CodingKey {
        case accommodationBudget = "accommodation_budget"
        case foodBudget = "food_budget"
        case sightseeingBudget = "sightseeing_budget"
        case travelTheme = "travel_theme"
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case recommendationRecords = "recommendation_records"
        case chatRooms = "chat_rooms"
        case travelSchedules = "travel_schedules"
    }
}
