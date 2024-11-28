import Foundation

// MARK: - WeatherDataModel
struct GetReadTravelSchedulesDTO: Codable {
    let travelSchedules: [ReadTravelSchedule]

    enum CodingKeys: String, CodingKey {
        case travelSchedules = "travel_schedules"
    }
}


struct ReadTravelSchedule: Codable {
    let tripName, startDate, endDate: String
    let id, userID: Int
    let createdAt, updatedAt: String
    let placesToVisit: [ReadPlacesToVisit]

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

// MARK: - PlacesToVisit
struct ReadPlacesToVisit: Codable {
    let userMemo: String
    let id, travelScheduleID, placeID, orderIndex: Int
    let createdAt: String
    let place: ReadPlace

    enum CodingKeys: String, CodingKey {
        case userMemo = "user_memo"
        case id
        case travelScheduleID = "travel_schedule_id"
        case placeID = "place_id"
        case orderIndex = "order_index"
        case createdAt = "created_at"
        case place
    }
}

// MARK: - Place
struct ReadPlace: Codable {
    let placeName: String
    let x, y: Double
    let roadAddressName: String
    let placeURL: String
    let visitorCharacteristics, estimatedCost, estimatedDuration: String
    let imgURL: String?
    let id: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case x, y
        case roadAddressName = "road_address_name"
        case placeURL = "place_url"
        case visitorCharacteristics = "visitor_characteristics"
        case estimatedCost = "estimated_cost"
        case estimatedDuration = "estimated_duration"
        case imgURL = "img_url"
        case id
        case createdAt = "created_at"
    }
}
