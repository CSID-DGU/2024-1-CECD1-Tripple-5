import Foundation

class UserRepository {
    func getReadUsers(completion: @escaping ((GetReadUsesrDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/users",
                                     callback: { (data: GetReadUsesrDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func postCreateUser(accommodationBudget: Int,
                        foodBudget: Int,
                        sightseeingBudget: Int,
                        travelTheme: String,
                        completion: @escaping ((PostCreateUserDTO) -> Void)) {
        let body: [String : Any] = ["accommodation_budget": accommodationBudget,
                                    "food_budget": foodBudget,
                                    "sightseeing_budget": sightseeingBudget,
                                    "travel_theme": travelTheme]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/users",
                                       callback: { (data: PostCreateUserDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func getReadUser(userId: String,
                     completion: @escaping ((GetReadUserDTO) -> Void)) {
        let body: [String : Any] = ["user_id": userId]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/users/\(userId)",
                                       callback: { (data: GetReadUserDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func putUpdateUser(userId: String,
                       accommodationBudget: Int,
                       foodBudget: Int,
                       sightseeingBudget: Int,
                       travelTheme: String,
                       completion: @escaping((PutUpdateUserDTO) -> Void)) {
        let body: [String : Any] = ["accommodation_budget": accommodationBudget,
                                    "food_budget": foodBudget,
                                    "sightseeing_budget": sightseeingBudget,
                                    "travel_theme": travelTheme]
        PUTService.shared.putService(with: body,
                                     from: AppConstants.baseURL + "/api/v1/users/\(userId)",
                                     callback: { (data: PutUpdateUserDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func deleteUser(userId: String,
                    completion: @escaping ((DeleteUserDTO) -> Void)) {
        DELETEService.shared.deleteService(from: AppConstants.baseURL + "/api/v1/users\(userId)",
                                           callback: { (data: DeleteUserDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
}
