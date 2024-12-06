import Foundation

struct ChatDetailDTO: Codable {
    let message: String
    let isChatbot: Bool
    let id, chatRoomID: Int
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case message
        case isChatbot = "is_chatbot"
        case id
        case chatRoomID = "chat_room_id"
        case timestamp
    }
}

// MARK: - Welcome
struct ChatDetailMessageDTO: Codable {
    let status, message: String
    let data: ChatDetailMessageItemDTO

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
struct ChatDetailMessageItemDTO: Codable {
    let recommendations: [Recommendations]

    enum CodingKeys: String, CodingKey {
        case recommendations = "recommendations"
    }
}

// MARK: - Recommendations
struct Recommendations: Codable {
    let placeName, type, categoryGroupName, categoryName: String
    let coordinates: Coordinates
    let roadAddressName: String
    let placeURL: String
    let estimatedCost, estimatedDuration: Int
    let visitorCharacteristics, recommendationReason: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case type
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case coordinates
        case roadAddressName = "road_address_name"
        case placeURL = "place_url"
        case estimatedCost = "estimated_cost"
        case estimatedDuration = "estimated_duration"
        case visitorCharacteristics = "visitor_characteristics"
        case recommendationReason = "recommendation_reason"
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let x, y: Float

    enum CodingKeys: String, CodingKey {
        case x = "x"
        case y = "y"
    }
}
