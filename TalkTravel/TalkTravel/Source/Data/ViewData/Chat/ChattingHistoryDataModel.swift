import Foundation

struct ChattingHistoryDataModel: Hashable {
    let identifier: UUID = .init()
    let title: String
    let roomId: String
}

enum chattingHistorySection: Equatable {
    case _default
}
