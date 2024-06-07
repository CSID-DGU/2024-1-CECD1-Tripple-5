import UIKit

extension NSObject {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
