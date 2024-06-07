import UIKit

import RxSwift
import RxCocoa

final class ChatViewModel {
    private let chatData: ChattingDataModel = .init(item: [.init(singleText: "어떤 서비스를 원하시나요?\n(맛집 추천/숙소 추천/관광지 추천)")])
    
    var datasource: UITableViewDiffableDataSource<ChattingSection, ChattingCellItemData>!
    
    func bindData() {
        var snapShot = datasource.snapshot()
        snapShot.appendSections([.chatBotSection])
        snapShot.appendItems(chatData.item)
        datasource.apply(snapShot)
    }
}

