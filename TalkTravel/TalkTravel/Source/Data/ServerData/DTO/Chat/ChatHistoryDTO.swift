import Foundation

struct ChatHistoryDTO: Codable {
    let chatRooms: [ChatRoom]

    enum CodingKeys: String, CodingKey {
        case chatRooms = "chat_rooms"
    }
}

// MARK: - ChatRoom
struct ChatRoom: Codable {
    let name: String
    let id: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
