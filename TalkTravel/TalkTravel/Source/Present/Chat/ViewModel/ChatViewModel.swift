import UIKit

import RxSwift
import RxCocoa

final class ChatViewModel {
    private var chatData: ChattingDataModel = .init(chatBotItem: [.init(isUserCell: false, 
                                                                        singleText: "어떤 서비스를 원하시나요?\n(맛집 추천/숙소 추천/관광지 추천)")])
    
    var datasource: UITableViewDiffableDataSource<ChattingSection, ChattingCellItemData>!
    
    func bindData() {
        var snapShot = datasource.snapshot()
        snapShot.appendSections([.chatBotSection])
        snapShot.appendItems(chatData.chatBotItem)
        datasource.apply(snapShot, animatingDifferences: false)
    }
    
    func addItem() {
        var snapShot = datasource.snapshot()
        snapShot.appendItems(chatData.chatBotItem)
        datasource.apply(snapShot, animatingDifferences: false)
    }
    
    func addUserItem(text: String) {
        chatData.chatBotItem.append(.init(isUserCell: true, singleText: text))
        addItem()
    }
}

