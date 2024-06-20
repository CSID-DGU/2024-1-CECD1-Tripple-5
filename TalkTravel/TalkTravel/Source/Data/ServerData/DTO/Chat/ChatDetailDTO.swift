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
import Foundation

// MARK: - WeatherDataModel
struct ChatDetailMessageDTO: Codable {
    let description: ChatDetailMessageItemDTO
}

struct ChatDetailMessageItemDTO: Codable {
    let content: String
    let places: [ChatPlace]
}

// MARK: - Place
struct ChatPlace: Codable {
    let name, location, latitude, longitude: String
    let description: String
    let url: String
}
