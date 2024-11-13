import Foundation

struct GetReadPlacesToVisitDTO: Codable {
    let placesToVisit: [GetReadPlacesPlacesToVisit]

    enum CodingKeys: String, CodingKey {
        case placesToVisit = "places_to_visit"
    }
}

// MARK: - PlacesToVisit
struct GetReadPlacesPlacesToVisit: Codable {
    let userMemo: String
    let id, travelScheduleID, placeID: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userMemo = "user_memo"
        case id
        case travelScheduleID = "travel_schedule_id"
        case placeID = "place_id"
        case createdAt = "created_at"
    }
}
