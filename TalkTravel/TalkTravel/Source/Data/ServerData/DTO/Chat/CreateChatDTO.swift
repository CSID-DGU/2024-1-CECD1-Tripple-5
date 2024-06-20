import Foundation

struct CreateChatDTO: Codable {
    let name: String
    let id: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
