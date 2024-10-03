final class PlanDetailViewModel {
    var detailData = PlanDetailDataModel(summaryData: .init(allPlaceLocation: [.init(lat: 37.5, lon: 128.0)],
                                                            allPlan: "2023.04.02 ~ 04.04",
                                                            allBudget: "6만원",
                                                            budgetDetail: [.init(placeName: "성산 일출봉",
                                                                                 budget: "10,000원"),
                                                                           .init(placeName: "성산 이출봉",
                                                                                 budget: "20,000원"),
                                                                           .init(placeName: "성산 삼출봉",
                                                                                 budget: "30,000원")]),
                                         detailData: [.init(placeName: "성산 일출봉",
                                                            meanBudget: "무료",
                                                            openingTime: "10:00 ~ 22:00",
                                                            location: .init(lat: 37.5, lon: 128.0)),
                                                      .init(placeName: "성산 일출봉",
                                                            meanBudget: "무료",
                                                            openingTime: "10:00 ~ 22:00",
                                                            location: .init(lat: 37.5, lon: 128.0)),
                                                      .init(placeName: "성산 일출봉",
                                                            meanBudget: "무료",
                                                            openingTime: "10:00 ~ 22:00",
                                                            location: .init(lat: 37.5, lon: 128.0)),
                                                      .init(placeName: "성산 일출봉",
                                                            meanBudget: "무료",
                                                            openingTime: "10:00 ~ 22:00",
                                                            location: .init(lat: 37.5, lon: 128.0))])
    
    init() {
        
    }
    
    
}
