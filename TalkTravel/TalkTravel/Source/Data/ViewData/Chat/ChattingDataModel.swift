import UIKit

struct ChattingDataModel: Hashable {
    let item: [ChattingCellItemData]
    let sectionProfileImage: UIImage = .icChat
    let sectionChatbotName: String = "AI 챗봇"
}

struct ChattingCellItemData: Hashable {
    let identifier: UUID = .init()
    var singleText: String?
    var placeName: String?
    var loacation: String?
    var link: String?
    var detail: String?
    var placeImagePath: String?
    var isAddPlan: Bool?
}
enum ChattingSection: Equatable {
    case chatBotSection
}
