struct ProfileViewData {
    let placeBudget: Float
    let foodBudget: Float
    let travelBudget: Float
    
    var themeSection1Data: [TravelThemeData]
    var themeSection2Data: [TravelThemeData]
    var themeSection3Data: [TravelThemeData]
}

struct TravelThemeData {
    let type: TravelThemeType
    var isSelected: Bool
}

enum TravelThemeType {
    case crowded
    case quiet
    case resort
    case viewwing
    case famous
    case local
    
    var title: String {
        switch self {
        case .crowded:
            return "붐비는"
        case .quiet:
            return "한적한"
        case .resort:
            return "휴양"
        case .viewwing:
            return "관람"
        case .famous:
            return "유명한"
        case .local:
            return "로컬"
        }
    }
}
