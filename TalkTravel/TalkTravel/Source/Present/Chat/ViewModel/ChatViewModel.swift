import UIKit

import RxSwift
import RxCocoa

final class ChatViewModel {
    var chatDataDict = [UUID: ChattingCellItemData]()
    var chatData: ChattingDataModel = .init(chatBotItem: [.init(isUserCell: false,
                                                                singleText: "어떤 서비스를 원하시나요?\n(맛집 추천/숙소 추천/관광지 추천)")])
    private var chatRepository = ChatbotRepository()
    
    var datasource: UITableViewDiffableDataSource<ChattingSection, UUID>!
    var updateChatData = PublishRelay<Void>()
    
    //Property
    private var roomId: String = ""
    var isFirstSelectBehaviorRelay = BehaviorSubject<Bool>(value: false)
    var addPlanCountRelay = PublishRelay<Int>()
    
    
    func resetData(roomId: String) {
        chatDataDict = [:]
        chatData = .init(chatBotItem: [.init(isUserCell: false,
                                             singleText: "어떤 서비스를 원하시나요?\n(맛집 추천/숙소 추천/관광지 추천)")])
        self.roomId = roomId
        self.resetData()
    }
    
    func resetData() {
        let snapShot = NSDiffableDataSourceSnapshot<ChattingSection, UUID>()
        datasource.apply(snapShot, animatingDifferences: false)
    }
    
    func countAddPlanNumber() {
        var count = 0
        for item in chatData.chatBotItem {
            if (item.isAddPlan ?? false) == true {
                count += 1
            }
        }
        print(count)
        addPlanCountRelay.accept(count)
    }
    
    func updateItem(identifier: UUID) {
        var snapshot = datasource.snapshot()
        snapshot.reloadItems([identifier])
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    func convertData() {
        let tuple = chatData.chatBotItem.map { ($0.identifier, $0) }
        let dict = Dictionary(uniqueKeysWithValues: tuple)
        self.chatDataDict = dict
    }
    
    func bindData() {
        convertData()
        var snapShot = datasource.snapshot()
        if !snapShot.sectionIdentifiers.contains([.chatBotSection]) {
            snapShot.appendSections([.chatBotSection])
        }
        let existingItems = Set(snapShot.itemIdentifiers(inSection: .chatBotSection))
        let newItems = chatDataDict.values.map { $0 }
            .map { $0.identifier }
            .filter { !existingItems.contains($0) }
        snapShot.appendItems(newItems, toSection: .chatBotSection)
        datasource.apply(snapShot, animatingDifferences: false)
        updateChatData.accept(())
    }
    
    func addUserItem(text: String) {
        UIWindow.key?.showLoadingIndicator()
        chatData.chatBotItem.append(.init(isUserCell: true, singleText: text))
        if roomId != "" {
            startChat(prompt: text)
        } else {
            createRoom(name: text,
                       prompt: text)
        }
        bindData()
    }
    
    private func removeEscapeWord(text: String) -> String {
        let originString = text.trimmingCharacters(in: ["\\", "n"])
        return originString
    }
    
    private func parseMessageToStruct(data: String) -> ChatDetailMessageDTO? {
        guard let data = data.data(using: .utf8, allowLossyConversion: false) else { return nil }
        guard let message = try? JSONDecoder().decode(ChatDetailMessageDTO.self, from: data) else { return nil }
        print(message)
        return message
    }
    
    //MARK: - Network
    func createRoom(name: String,
                    prompt: String) {
        chatRepository.createChatRoom(name: name,
                                      completion: { [weak self] result in
            guard let self else { return }
            self.roomId = String(result.id)
            startChat(prompt: prompt)
        })
    }
    
    func startChat(prompt: String) {
        chatRepository.chatDetailPost(id: self.roomId,
                                      prompt: prompt,
                                      isChatbot: false,
                                      completion: { [weak self] result in
            guard let self else { return }
            if let messageData = parseMessageToStruct(data: removeEscapeWord(text: result.message)) {
                messageData.description.places.forEach {
                    self.chatData.chatBotItem.append(.init(isUserCell: !result.isChatbot,
                                                           singleText: messageData.description.content,
                                                           placeName: "이름: " + $0.name,
                                                           loacation: "위치: " + $0.location,
                                                           detailLocation: .init(long: $0.longitude,
                                                                                 lat: $0.latitude),
                                                           link: "link: " + $0.url,
                                                           detail: "상세 설명: " + $0.description,
                                                           placeImagePath: nil,
                                                           isAddPlan: false))
                    
                }
                self.bindData()
            } else {
                self.chatData.chatBotItem.append(.init(isUserCell: false,
                                                       singleText: result.message))
                self.bindData()
            }
            UIWindow.key?.removeLoadingIndicator()
        })
    }
    
    func getChatHistoryData() {
        UIWindow.key?.showLoadingIndicator()
        chatRepository.getChatbotHistory(id: self.roomId, completion: { [weak self] result in
            guard let self else { return }
            result.chatRecords.forEach { result in
                if let messageData = self.parseMessageToStruct(data: self.removeEscapeWord(text: result.message)) {
                    messageData.description.places.forEach {
                        self.chatData.chatBotItem.append(.init(isUserCell: !result.isChatbot,
                                                               singleText: messageData.description.content,
                                                               placeName: "이름: " + $0.name,
                                                               loacation: "위치: " + $0.location,
                                                               detailLocation: .init(long: $0.longitude,
                                                                                     lat: $0.latitude),
                                                               link: "link: " + $0.url,
                                                               detail: "상세 설명: " + $0.description,
                                                               placeImagePath: nil,
                                                               isAddPlan: false))
                    }
                    self.bindData()
                } else {
                    self.chatData.chatBotItem.append(.init(isUserCell: !result.isChatbot,
                                                           singleText: result.message))
                    self.bindData()
                }
            }
            UIWindow.key?.removeLoadingIndicator()
        })
    }
    
    
}

