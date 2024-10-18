import Foundation

// MARK: - Welcome
struct GetReadChatRooms: Codable {
    let chatRooms: [ReadChatRooms]

    enum CodingKeys: String, CodingKey {
        case chatRooms = "chat_rooms"
    }
}

// MARK: - ChatRoom
struct ReadChatRooms: Codable {
    let chatRoomName: String
    let id, userID: Int
    let createdAt, updatedAt: String
    let chatRecords: [String]

    enum CodingKeys: String, CodingKey {
        case chatRoomName = "chat_room_name"
        case id
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case chatRecords = "chat_records"
    }
}

