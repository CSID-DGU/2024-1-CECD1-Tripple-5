import UIKit

import RxSwift
import RxRelay

final class SearchViewModel {
    private var placeRepository: PlaceRepository
    var searchResults: [SearchItemData] = []
    
    var refreshRelay = PublishRelay<Void>()
    
    init(placeRepository: PlaceRepository) {
        self.placeRepository = placeRepository
    }
    
    func getPlaces(query: String) {
        placeRepository.getSearchPlace(unifiedSearchTerm: query,
                                       completion: { [weak self] result in
            guard let self else { return }
            self.searchResults = result.places.map { .init(id: $0.id,
                                                      title: $0.placeName,
                                                      imageUrl: $0.imgURL,
                                                      location: $0.roadAddressName)}
            self.refreshRelay.accept(())
        })
    }
}
