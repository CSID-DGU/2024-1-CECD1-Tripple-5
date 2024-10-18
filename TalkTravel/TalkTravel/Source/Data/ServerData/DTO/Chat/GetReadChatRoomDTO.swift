// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct GetReadChatRoomDTO: Codable {
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
