import Foundation

// MARK: - Welcome
struct GetReadChatRecordsDTO: Codable {
    let chatRecords: [ReadChatRecord]

    enum CodingKeys: String, CodingKey {
        case chatRecords = "chat_records"
    }
}

// MARK: - ChatRecord
struct ReadChatRecord: Codable {
    let message: String
    let isChatbot: Bool
    let id, chatRoomID: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case message
        case isChatbot = "is_chatbot"
        case id
        case chatRoomID = "chat_room_id"
        case createdAt = "created_at"
    }
}
