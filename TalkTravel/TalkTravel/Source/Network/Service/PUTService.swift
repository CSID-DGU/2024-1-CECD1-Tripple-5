import Foundation
import Alamofire

final class PUTService {
    static let shared = PUTService()
    private init() {}
    func putService <T: Decodable> (with param: Parameters,
                                     isUseHeader: Bool = false,
                                     from url: String,
                                     callback: @escaping (_ data: T?, _ error: String?) -> ()) {
        AF.request(url,
                   method: .put,
                   parameters: param,
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
