import UIKit

import RxSwift

final class ChatbotHistoryViewModel {
    private var chatbotRepository = ChatbotRepository()
    
    var historyDataDict = [UUID: ChattingHistoryDataModel]()
    private var historyData: [ChattingHistoryDataModel] = []
    
    var datasource: UITableViewDiffableDataSource<chattingHistorySection, UUID>!
    
    func convertData() {
        let tuple = historyData.map { ($0.identifier, $0) }
        let dict = Dictionary(uniqueKeysWithValues: tuple)
        historyDataDict = dict
    }
    
    func bindData() {
        convertData()
        var snapShot = datasource.snapshot()
        if !snapShot.sectionIdentifiers.contains([._default]) {
            snapShot.appendSections([._default])
        }
        let existingItems = Set(snapShot.itemIdentifiers(inSection: ._default))
        let newItems = historyDataDict.values.map { $0 }
            .sorted(by: { $0.roomId > $1.roomId})
            .map { $0.identifier }
            .filter { !existingItems.contains($0) }
        snapShot.appendItems(newItems, toSection: ._default)
        datasource.apply(snapShot, animatingDifferences: false)
    }
    
    func getHistoryData() {
        chatbotRepository.getChatRooms(completion: { [weak self] result in
            guard let self else { return }
            print(result)
            self.historyData = result.chatRooms.map { .init(title: $0.name,
                                                            roomId: String($0.id)) }
            bindData()
        })
    }
    
}
