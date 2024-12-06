import Foundation

class TravelRepository {
    func getReadTravelSchedules(userId: String,
                                completion: @escaping ((GetReadTravelSchedulesDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/users/\(userId)/travel_schedules",
                                     callback: { (data: GetReadTravelSchedulesDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func postTravelSchedule(userId: String,
                            tripName: String,
                            startDate: String,
                            endDate: String,
                            completion: @escaping ((PostCreateTravelScheduleDTO) -> Void)) {
        let body: [String: Any] = ["trip_name": tripName,
                                   "start_date": startDate,
                                   "end_date": endDate]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/users/\(userId)/travel_schedules",
                                       callback: { (data: PostCreateTravelScheduleDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func getReadTravelScheduleForScheduleId(scheduleId: String,
                                            completion: @escaping ((GetReadTravelSchedulesDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/travel_schedules/\(scheduleId)",
                                     callback: { (data: GetReadTravelSchedulesDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func deleteTravelSchedule(scheduleId: String,
                              completion: @escaping ((DeleteTravelScheduleDTO) -> Void)) {
        DELETEService.shared.deleteService(from: AppConstants.baseURL + "/api/v1/travel_schedules/\(scheduleId)",
                                           callback: { (data: DeleteTravelScheduleDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
                                     
    }
    
    func getReadPlacesToVisit(travelScheduleId: Int,
                              completion: @escaping ((GetReadPlacesToVisitDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/travel_schedules/\(travelScheduleId)/places_to_visit",
                                     callback: { (data: GetReadPlacesToVisitDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func postCreatePlaceToVisit(travelScheduleId: Int,
                                userMemo: String,
                                placeId: Int,
                                completion: @escaping ((PostCreatePlaceToVisitDTO) -> Void)) {
        let body: [String: Any] = ["user_memo": userMemo,
                                   "place_id": placeId]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/travel_schedules/\(travelScheduleId)/places_to_visit",
                                       callback: { (data: PostCreatePlaceToVisitDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func putPlaceToVisit(placeToVisitId: Int,
                         userMemo: String,
                         placeId: Int,
                         completion: @escaping ((PutPlaceToVisitDTO) -> Void)) {
        let body: [String: Any] = ["user_memo": userMemo,
                                   "place_id": placeId]
        PUTService.shared.putService(with: body,
                                     from: AppConstants.baseURL + "/api/v1/places_to_visit/\(placeToVisitId)",
                                     callback: { (data: PutPlaceToVisitDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func deletePlaceToVisit(placeToVisitId: Int,
                            userMemo: String,
                            placeId: Int,
                            completion: @escaping ((DeletePlaceToVisitDTO) -> Void)) {
        DELETEService.shared.deleteService(from: AppConstants.baseURL + "/api/v1/places_to_visit/\(placeToVisitId)",
                                           callback: { (data: DeletePlaceToVisitDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
        
    }
    
}
