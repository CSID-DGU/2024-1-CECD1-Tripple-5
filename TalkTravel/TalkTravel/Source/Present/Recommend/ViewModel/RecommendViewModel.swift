import Foundation

import RxSwift
import RxRelay

final class RecommendViewModel {
    private var recommendationRepository: RecommendationRepository
    private var placeRepository: PlaceRepository
    
    var themePlaceUpdateRelay = PublishRelay<Void>()
    var recommendPlaceUpdateRelay = PublishRelay<Void>()
    
    init(recommendationRepository: RecommendationRepository,
         placeRepository: PlaceRepository) {
        self.recommendationRepository = recommendationRepository
        self.placeRepository = placeRepository
    }
    
    var themePlaceDatas: [RecommendCellViewData] = []
    var recommendPlaceDatas: [RecommendCellViewData] = []
    
    private func setSearchText() -> String {
        let type1 = UserDefaults.crowded && UserDefaults.resort && UserDefaults.famous
        let type2 = UserDefaults.crowded && UserDefaults.resort && !UserDefaults.famous
        let type3 = UserDefaults.crowded && !UserDefaults.resort && UserDefaults.famous
        let type4 = !UserDefaults.crowded && UserDefaults.resort && UserDefaults.famous
        let type5 = UserDefaults.crowded && !UserDefaults.resort && !UserDefaults.famous
        let type6 = !UserDefaults.crowded && !UserDefaults.resort && !UserDefaults.famous
        
        if type1 {
            return "호텔"
        } else if type2 {
            return "게스트"
        } else if type3 {
            return "영화"
        } else if type4 {
            return "연극"
        } else if type5 {
            return "대규모"
        } else if type6 {
            return "소규모"
        } else {
            return "여행"
        }
    }
    
    func getThemePlaceData() {
        placeRepository
            .getSearchPlace(unifiedSearchTerm: setSearchText(),
                            completion: { [weak self] data in
                guard let self else { return }
                self.themePlaceDatas = data.places.map { .init(placeId: $0.id,
                                                               placeImagePath: $0.imgURL,
                                                               placeTitle: $0.placeName,
                                                               localeTitle: $0.roadAddressName)}
                self.themePlaceUpdateRelay.accept(())
            })
    }
    
    func getRecommendationData() {
        recommendationRepository
            .getReadRecommendationRecords(userId: 1,
                                          completion: { [weak self] data in
                guard let self else { return }
                self.recommendPlaceDatas = data.recommendationRecordsDetail.map { .init(placeId: $0.placeID,
                                                                                    placeImagePath: $0.place.imgURL,
                                                                                    placeTitle: $0.place.placeName,
                                                                                    localeTitle: $0.place.roadAddressName)}
                self.recommendPlaceUpdateRelay.accept(())
            })
    }
    
}
