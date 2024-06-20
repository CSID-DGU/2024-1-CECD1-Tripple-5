import UIKit

struct ChattingDataModel: Hashable {
    var chatBotItem: [ChattingCellItemData]
    let sectionProfileImage: UIImage = .icChat
    let sectionChatbotName: String = "AI 챗봇"
}

struct ChattingCellItemData: Hashable {
    var identifier: UUID = .init()
    var isUserCell: Bool
    var singleText: String?
    var placeName: String?
    var loacation: String?
    var detailLocation: ChatLocationData?
    var link: String?
    var detail: String?
    var placeImagePath: String?
    var isAddPlan: Bool?
}

struct ChatLocationData: Hashable {
    let long: String
    let lat: String
}

enum ChattingSection: Equatable {
    case chatBotSection
}
