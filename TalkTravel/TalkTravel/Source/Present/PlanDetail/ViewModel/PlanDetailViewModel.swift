import Foundation

final class PlanDetailViewModel {
    private var travelRepository: TravelRepository
    var travelScheduleId: Int = 0
    
    
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
    
    init(travelRepository: TravelRepository) {
        self.travelRepository = travelRepository
    }
    
    func getDetailData(completion: (() -> Void)?) {
        travelRepository.getReadPlacesToVisit(travelScheduleId: travelScheduleId,
                                              completion: { [weak self] result in
            guard let self else { return }
            detailData.summaryData = .init(allPlaceLocation: result.placesToVisit.map { .init(lat: min($0.place.x, $0.place.y),
                                                                                              lon: max($0.place.x, $0.place.y))},
                                           allPlan: "\(Date().getDateString()) ~ \(Date().getNextDateString(value: 1))",
                                           allBudget: String(result.placesToVisit.map { Int((Float($0.place.estimatedCost) ?? 0) / 10000.0) }.reduce(0, +)),
                                           budgetDetail: result.placesToVisit.map { .init(placeName: $0.place.placeName,
                                                                                          budget: String(Int(Float($0.place.estimatedCost) ?? 0)))})
            print(result)
            
            detailData.detailData = result.placesToVisit.map { .init(placeName: $0.place.placeName,
                                                                     meanBudget: String(Int(Float($0.place.estimatedCost) ?? 0)),
                                                                     openingTime: "정보 없음",
                                                                     location: .init(lat: min($0.place.x, $0.place.y),
                                                                                     lon: max($0.place.x, $0.place.y)))}
            completion?()
        })
    }
    
    
}
