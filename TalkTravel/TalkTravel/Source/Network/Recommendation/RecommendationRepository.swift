import Foundation

class RecommendationRepository {
    func getReadRecommendationRecords(userId: Int,
                                      completion: @escaping ((GetReadRecommendationRecordsDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/users/\(userId)/recommendation_records",
                                     callback: { (data: GetReadRecommendationRecordsDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func postCreateRecommendationRecord(userId: Int,
                                        recommendationName: String,
                                        placeId: Int,
                                        completion: @escaping ((PostCreateRecommendationRecordDTO) -> Void)) {
        let body: [String: Any] = ["recommendation_name": recommendationName,
                                   "place_id": placeId]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/users/\(userId)/recommendation_records",
                                       callback: { (data: PostCreateRecommendationRecordDTO?, error) in
              guard let data = data else {
                  return
              }
              completion(data)
          })
    }
    
    
    
    func getReadRecommendationRecord(recordId: Int,
                                     completion: @escaping ((GetReadRecommendationRecordDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/recommendation_records/\(recordId)",
                                     callback: { (data: GetReadRecommendationRecordDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func deletePlace(recordId: Int,
                     completion: @escaping ((DeleteRecommendationRecordDTO) -> Void)) {
        DELETEService.shared.deleteService(from: AppConstants.baseURL + "/api/v1/recommendation_records/\(recordId)",
                                           callback: { (data: DeleteRecommendationRecordDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
}
