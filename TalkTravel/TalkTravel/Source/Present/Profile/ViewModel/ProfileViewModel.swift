import Foundation

final class ProfileViewModel {
    
    var profileViewData = ProfileViewData(placeBudget: 0.5,
                                          foodBudget: 0.5,
                                          travelBudget: 0.5,
                                          themeSection1Data: [],
                                          themeSection2Data: [.init(type: .resort,
                                                                    isSelected: true),
                                                              .init(type: .viewwing,
                                                                    isSelected: false)],
                                          themeSection3Data: [.init(type: .famous,
                                                                    isSelected: true),
                                                              .init(type: .local,
                                                                    isSelected: false)])
    
    init() {
        setProfileData()
    }
    
    private func setProfileData() {
        profileViewData.themeSection1Data = [.init(type: .crowded,
                                                   isSelected: UserDefaults.crowded),
                                             .init(type: .quiet,
                                                   isSelected: !UserDefaults.crowded)]
        profileViewData.themeSection2Data = [.init(type: .resort,
                                                   isSelected: UserDefaults.resort),
                                             .init(type: .viewwing,
                                                   isSelected: !UserDefaults.resort)]
        profileViewData.themeSection3Data = [.init(type: .famous,
                                                   isSelected: UserDefaults.famous),
                                             .init(type: .local,
                                                   isSelected: !UserDefaults.famous)]
    }
    
    
    func updateUserData() {
        UserDefaults.crowded = profileViewData.themeSection1Data[0].isSelected
        UserDefaults.resort = profileViewData.themeSection2Data[0].isSelected
        UserDefaults.famous = profileViewData.themeSection3Data[0].isSelected
    }
    
}
