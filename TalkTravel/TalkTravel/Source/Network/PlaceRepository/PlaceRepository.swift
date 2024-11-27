import Foundation

class PlaceRepository {
    func getSearchPlace(unifiedSearchTerm: String,
                        completion: @escaping ((GetSearchPlaceDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/places?unified_search_term=\(unifiedSearchTerm)",
                                     callback: { (data: GetSearchPlaceDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func postCreatePlace(placeName: String,
                         x: Double,
                         y: Double,
                         roadAddressName: String,
                         placeUrl: String,
                         placeDescription: String,
                         placeCost: Int,
                         completion: @escaping ((PostCreatePlaceDTO) -> Void)) {
        let body: [String: Any] = ["place_name": placeName,
                                   "x": x,
                                   "y": y,
                                   "road_address_name": roadAddressName,
                                   "place_url": placeUrl,
                                   "place_description": placeDescription,
                                   "place_cost": placeCost]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/places",
                                       callback: { (data: PostCreatePlaceDTO?, error) in
              guard let data = data else {
                  return
              }
              completion(data)
          })
    }
    
    func getSearchPlace(placeId: Int,
                        completion: @escaping ((GetReadPlaceDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/places/\(placeId)",
                                     callback: { (data: GetReadPlaceDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func deletePlace(placeId: Int,
                     completion: @escaping ((DeletePlaceDTO) -> Void)) {
        DELETEService.shared.deleteService(from: AppConstants.baseURL + "/api/v1/places/\(placeId)",
                                           callback: { (data: DeletePlaceDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
}
