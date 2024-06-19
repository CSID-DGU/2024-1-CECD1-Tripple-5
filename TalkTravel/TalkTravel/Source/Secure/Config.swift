import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let KAKAO_APP_KEY = "KAKAO_APP_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
}
