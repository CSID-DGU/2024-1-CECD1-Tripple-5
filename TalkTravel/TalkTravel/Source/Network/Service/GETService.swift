import Foundation
import Alamofire

class GETService {
    static let shared = GETService()
    private init() {}
    func getService <T: Decodable> (from url: String,
                                    isUseHeader: Bool = false,
                                    callback: @escaping (_ data: T?, _ error: String?) -> ()) {
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"]).response { response in
            do {
                print("\n\n 😎 ErrorCode is : \(response.response?.statusCode)\n\n")
                guard let resData = response.data else {
                    callback(nil, "emptyData")
                    return
                }
                let data = try JSONDecoder().decode(T.self, from: resData)
                callback(data, nil)
            } catch {
                callback(nil, error.localizedDescription)
            }
        }
    }
    
}
