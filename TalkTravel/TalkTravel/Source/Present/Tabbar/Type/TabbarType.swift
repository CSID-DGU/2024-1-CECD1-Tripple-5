import Foundation

enum TabbarType: String, CaseIterable {
    case recommend, chat, travelPlan, profile
    
    init?(index: Int) {
        switch index {
        case 0: self = .recommend
        case 1: self = .chat
        case 2: self = .travelPlan
        case 3: self = .profile
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .recommend: return 0
        case .chat: return 1
        case .travelPlan: return 2
        case .profile: return 3
        }
    }
}
