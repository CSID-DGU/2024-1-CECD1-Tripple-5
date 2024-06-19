import UIKit

import RxSwift

final class ChatbotHistoryViewModel {
    private var historyData: [ChattingHistoryDataModel] = [.init(title: "테스트 데이터1"),
                                                           .init(title: "테스트 데이터2"),
                                                           .init(title: "테스트 데이터3")]
    
    var datasource: UITableViewDiffableDataSource<chattingHistorySection, ChattingHistoryDataModel>!
    
    func bindData() {
        var snapShot = datasource.snapshot()
        snapShot.appendSections([._default])
        snapShot.appendItems(historyData)
        datasource.apply(snapShot, animatingDifferences: false)
    }
    
    func addItem() {
        var snapShot = datasource.snapshot()
        snapShot.appendItems(historyData)
        datasource.apply(snapShot, animatingDifferences: false)
    }
}
