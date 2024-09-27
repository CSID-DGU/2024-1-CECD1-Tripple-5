final class ProfileViewModel {
    
    var profileViewData = ProfileViewData(placeBudget: 0.5,
                                          foodBudget: 0.5,
                                          travelBudget: 0.5,
                                          themeSection1Data: [.init(type: .crowded,
                                                                    isSelected: true),
                                                              .init(type: .quiet,
                                                                    isSelected: false)],
                                          themeSection2Data: [.init(type: .resort,
                                                                    isSelected: true),
                                                              .init(type: .viewwing,
                                                                    isSelected: false)],
                                          themeSection3Data: [.init(type: .famous,
                                                                    isSelected: true),
                                                              .init(type: .local,
                                                                    isSelected: false)])
    
    init() {
        
    }
    
}
