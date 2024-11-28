import UIKit
import CoreLocation

import RxSwift
import RxCocoa

final class ChatViewModel: NSObject {
    var chatDataDict = [UUID: ChattingCellItemData]()
    var chatData: ChattingDataModel = .init(chatBotItem: [.init(isUserCell: false,
                                                                singleText: "어떤 서비스를 원하시나요?\n(맛집 추천/숙소 추천/관광지 추천)")])
    
    var locationManager = CLLocationManager()

    private var chatRepository: ChatbotRepository
    private var travelRepository: TravelRepository
    
    private var userLon: Double = 0
    private var userLat: Double = 0
    
    var datasource: UITableViewDiffableDataSource<ChattingSection, UUID>!
    var updateChatData = PublishRelay<Void>()
    
    //Property
    private var roomId: String = ""
    private var roomTitle: String = ""
    var isFirstSelectBehaviorRelay = BehaviorSubject<Bool>(value: false)
    var addPlanCountRelay = PublishRelay<Int>()
    
    init(chatRepository: ChatbotRepository,
         travelRepository: TravelRepository) {
        self.chatRepository = chatRepository
        self.travelRepository = travelRepository
        super.init()
        checkAuthorizationStatus()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func checkAuthorizationStatus() {
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == .authorizedAlways
                || locationManager.authorizationStatus == .authorizedWhenInUse {
                print("==> 위치 서비스 On 상태")
                locationManager.startUpdatingLocation() //위치 정보 받아오기 시작 - 사용자의 현재 위치를 보고하는 업데이트 생성을 시작
            } else if locationManager.authorizationStatus == .notDetermined {
                print("==> 위치 서비스 Off 상태")
                locationManager.requestWhenInUseAuthorization()
            } else if locationManager.authorizationStatus == .denied {
                print("==> 위치 서비스 Deny 상태")
            }
        } else {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                locationManager.startUpdatingLocation() //위치 정보 받아오기 시작 - 사용자의 현재 위치를 보고하는 업데이트 생성을 시작
                print("LocationViewController >> checkPermission() - \(locationManager.location?.coordinate)")
            } else {
                print("위치 서비스 Off 상태")
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
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
        let originString = text.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
        return originString
    }

    private func parseMessageToStruct(data: String) -> ChatDetailMessageItemDTO? {
        let cleanedData = removeEscapeWord(text: data)
        guard let jsonData = cleanedData.data(using: .utf8, allowLossyConversion: false) else { return nil }
        guard let message = try? JSONDecoder().decode(ChatDetailMessageDTO.self, from: jsonData) else { return nil }
        return message.data
    }
    //MARK: - Network
    func createRoom(name: String,
                    prompt: String) {
        locationManager.startUpdatingLocation()
        chatRepository.postCreateChatRoom(userId: 1,
                                          chatRoomName: name,
                                          completion: { [weak self] result in
            guard let self else { return }
            self.roomId = String(result.id)
            self.roomTitle = name
            startChat(prompt: prompt)
        })
    }
    
    func startChat(prompt: String) {
        chatRepository.postCreateChatRecords(chatRoomId: self.roomId,
                                             x: userLon,
                                             y: userLat,
                                             message: prompt,
                                             isChatbot: false,
                                             completion: { [weak self] result in
            guard let self else { return }
            if let messageData = parseMessageToStruct(data: removeEscapeWord(text: result.message)) {
                messageData.recommendations.forEach { [weak self] places in
                    guard let self else { return }
                    self.chatData.chatBotItem.append(.init(isUserCell: !result.isChatbot,
                                                           singleText: "",
                                                           placeName: "이름: " + places.placeName,
                                                           loacation: "위치: " + places.roadAddressName,
                                                           detailLocation: .init(long: places.coordinates.x,
                                                                                 lat: places.coordinates.y),
                                                           link: "link: " + places.placeURL,
                                                           detail: "상세 설명: " + places.recommendationReason,
                                                           placeImagePath: nil,
                                                           isAddPlan: false))
                }
            } else {
                self.chatData.chatBotItem.append(.init(isUserCell: false,
                                                       singleText: "오류가 발생했습니다."))
            }
            self.bindData()
            UIWindow.key?.removeLoadingIndicator()
        })
    }
    
    func getChatHistoryData() {
        self.chatData.chatBotItem.removeAll()
        chatRepository.getReadChatRoom(chatRoomId: self.roomId,
                                       completion: { [weak self] result in
            guard let self else { return }
            result.chatRecords.forEach { [weak self] chatRecord in
                guard let self else { return }
                if let messageData = parseMessageToStruct(data: removeEscapeWord(text: chatRecord.message)) {
                    messageData.recommendations.forEach { [weak self] places in
                        guard let self else { return }
                        self.chatData.chatBotItem.append(.init(isUserCell: !chatRecord.isChatbot,
                                                               singleText: "",
                                                               placeName: "이름: " + places.placeName,
                                                               loacation: "위치: " + places.roadAddressName,
                                                               detailLocation: .init(long: places.coordinates.x,
                                                                                     lat: places.coordinates.y),
                                                               link: "link: " + places.placeURL,
                                                               detail: "상세 설명: " + places.recommendationReason,
                                                               placeImagePath: nil,
                                                               isAddPlan: false))
                    }
                } else {
                    if chatRecord.isChatbot {
                        self.chatData.chatBotItem.append(.init(isUserCell: false,
                                                               singleText: "오류가 발생했습니다."))
                    } else {
                        self.chatData.chatBotItem.append(.init(isUserCell: true,
                                                               singleText: chatRecord.message))
                    }
                }
                self.bindData()
                UIWindow.key?.removeLoadingIndicator()
            }
        })
    }
    
    func getRoomDatas() {
        chatRepository.getReadChatRoom(chatRoomId: self.roomId,
                                       completion: { [weak self] result in
            guard let self else { return }
            self.roomId = result.chatRoomName
        })
    }
    
    func postMakePlan() {
        travelRepository.postTravelSchedule(userId: "1",
                                            tripName: roomTitle,
                                            startDate: Date().getDateString(),
                                            endDate: Date().getNextDateString(value: 1),
                                            completion: { [weak self] result in
            guard let self else { return }
        })
    }
    
}
extension ChatViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var longitude = CLLocationDegrees()
        var latitude = CLLocationDegrees()
         
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
            userLon = location.coordinate.latitude
            userLat = location.coordinate.longitude
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("locationManager >> didChangeAuthorization 🐥 ")
        locationManager.startUpdatingLocation()  //위치 정보 받아오기 start
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager >> didFailWithError 🐥 ")
    }
    
}
