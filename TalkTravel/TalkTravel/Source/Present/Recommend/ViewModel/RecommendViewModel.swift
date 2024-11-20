import Foundation

import RxSwift
import RxRelay

final class RecommendViewModel {
    private var recommendationRepository: RecommendationRepository
    private var placeRepository: PlaceRepository
    
    private var themePlaceUpdateRelay = PublishRelay<Void>()
    private var recommendPlaceUpdateRelay = PublishRelay<Void>()
    
    init(recommendationRepository: RecommendationRepository,
         placeRepository: PlaceRepository) {
        self.recommendationRepository = recommendationRepository
        self.placeRepository = placeRepository
    }
    
    var themePlaceDatas: [RecommendCellViewData] = [.init(placeId: 0,
                                                          placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                          placeTitle: "협재 해수욕장",
                                                          localeTitle: "제주도"),
                                                    .init(placeId: 0,
                                                          placeImagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRD1mxhx538Jzi2MLDOMqOZ0udvBxs5FvpnJA&s",
                                                          placeTitle: "사계해변",
                                                          localeTitle: "제주도"),
                                                    .init(placeId: 0,
                                                          placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                          placeTitle: "협재 해수욕장",
                                                          localeTitle: "제주도"),
                                                    .init(placeId: 0,
                                                          placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                          placeTitle: "협재 해수욕장",
                                                          localeTitle: "제주도"),
                                                    .init(placeId: 0,
                                                          placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                          placeTitle: "협재 해수욕장",
                                                          localeTitle: "제주도"),]
    
    var recommendPlaceDatas: [RecommendCellViewData] = [.init(placeId: 0,
                                                              placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                              placeTitle: "협재 해수욕장",
                                                              localeTitle: "제주도"),
                                                        .init(placeId: 0,
                                                              placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                              placeTitle: "협재 해수욕장",
                                                              localeTitle: "제주도"),
                                                        .init(placeId: 0,
                                                              placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                              placeTitle: "협재 해수욕장",
                                                              localeTitle: "제주도"),
                                                        .init(placeId: 0,
                                                              placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                              placeTitle: "협재 해수욕장",
                                                              localeTitle: "제주도"),
                                                        .init(placeId: 0,
                                                              placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
                                                              placeTitle: "협재 해수욕장",
                                                              localeTitle: "제주도"),]
    
//    func getThemePlaceData() {
//        recommendationRepository
//            .getReadRecommendationRecords(userId: 1,
//                                          completion: { [weak self] data in
//                guard let self else { return }
//                self.themePlaceDatas = data.recommendationRecords.map { .init(placeId: $0.placeID,
//                                                                              placeImagePath: "https://dimg.donga.com/wps/NEWS/IMAGE/2020/07/18/102027105.1.jpg",
//                                                                              placeTitle: $0.recommendationName,
//                                                                              localeTitle: $0.)}
//                self.themePlaceUpdateRelay.accept(())
//            })
//    }
//    
//    func getPlaceData(placeId: [Int]) {
//        placeRepository
//            .getSearchPlace(placeId: <#T##Int#>,
//                            completion: {
//                
//            })
//    }
//    
}
