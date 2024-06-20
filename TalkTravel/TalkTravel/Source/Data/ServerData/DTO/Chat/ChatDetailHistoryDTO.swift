// MARK: - WeatherDataModel
struct ChatDetailHistoryDTO: Codable {
    let chatRecords: [ChatRecord]

    enum CodingKeys: String, CodingKey {
        case chatRecords = "chat_records"
    }
}

// MARK: - ChatRecord
struct ChatRecord: Codable {
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


