import Foundation

final class ProfileViewModel {
    private var userRepository: UserRepository
    private let minValue: Float = 10
    private let maxValue: Float = 100
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
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getProfileData(completion: (() -> Void)?) {
        self.userRepository.getReadUser(userId: "1",
                                        completion: { [weak self] data in
            guard let self else { return }
            self.profileViewData = .init(placeBudget: (Float(data.accommodationBudget) ?? 0) / 10000,
                                         foodBudget: (Float(data.foodBudget) ?? 0) / 10000,
                                         travelBudget: (Float(data.sightseeingBudget) ?? 0) / 10000,
                                         themeSection1Data: [],
                                         themeSection2Data: [],
                                         themeSection3Data: [])
            print(self.profileViewData)
            self.setProfileData()
            completion?()
        })
    }
    
    func updateProfileData(placeBudget: Float,
                           foodBudget: Float,
                           travelBudget: Float) {
        self.userRepository.putUpdateUser(userId: "1",
                                          accommodationBudget: Int(placeBudget),
                                          foodBudget: Int(foodBudget),
                                          sightseeingBudget: Int(travelBudget),
                                          travelTheme: "영화",
                                          completion: { [weak self] _ in
        })
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
