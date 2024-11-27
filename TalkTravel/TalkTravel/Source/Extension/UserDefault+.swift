import UIKit
import AVFoundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    @UserDefault(key: "crowded", defaultValue: false)
    static var crowded: Bool
    @UserDefault(key: "quiet", defaultValue: false)
    static var quiet: Bool
    
    @UserDefault(key: "resort", defaultValue: false)
    static var resort: Bool
    @UserDefault(key: "viewwing", defaultValue: false)
    static var viewwing: Bool
    
    @UserDefault(key: "famous", defaultValue: false)
    static var famous: Bool
    @UserDefault(key: "local", defaultValue: false)
    static var local: Bool

}




