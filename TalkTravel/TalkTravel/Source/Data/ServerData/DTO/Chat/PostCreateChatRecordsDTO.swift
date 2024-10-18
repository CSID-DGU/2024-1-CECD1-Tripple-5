// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct PostCreateChatRecordsDTO: Codable {
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
