import Foundation

struct AppConstants {
    static let tabbarHeight: CGFloat = 58
    static let baseURL: String = "http://" + (Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.BASE_URL) as! String)
}
