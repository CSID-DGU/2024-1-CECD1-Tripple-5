import Foundation

// MARK: - Welcome
struct GetReadUserDTO: Codable {
    let accommodationBudget, foodBudget, sightseeingBudget: String
    let travelTheme: String
    let id: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case accommodationBudget = "accommodation_budget"
        case foodBudget = "food_budget"
        case sightseeingBudget = "sightseeing_budget"
        case travelTheme = "travel_theme"
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
