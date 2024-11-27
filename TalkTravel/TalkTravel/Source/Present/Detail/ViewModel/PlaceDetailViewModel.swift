import Foundation
import RxSwift

final class PlaceDetailViewModel {
    private var placeRepository: PlaceRepository
    var placeId: Int = 0
    var viewData: PlaceDetailViewData?
    
    init(placeRepository: PlaceRepository) {
        self.placeRepository = placeRepository
    }
    
    func getPlaceDetailData(completion: (() -> Void)?) {
        placeRepository.getSearchPlace(placeId: placeId,
                                       completion: { [weak self] data in
            guard let self else { return }
            self.viewData = .init(placeTitle: data.placeName,
                                  imagePath: data.imgURL,
                                  placeDescriptionTitle: data.placeName,
                                  placeDescription: data.visitorCharacteristics,
                                  locationTitle: data.roadAddressName,
                                  lat: data.x,
                                  lon: data.y)
            completion?()
        })
    }
}
