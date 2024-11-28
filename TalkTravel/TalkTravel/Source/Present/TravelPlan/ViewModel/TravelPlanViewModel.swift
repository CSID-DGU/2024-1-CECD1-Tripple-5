import Foundation

final class TravelPlanViewModel {
    private var travelRepository: TravelRepository
    
    var travelPlanHistoryData: [TravelPlanCellData] = []
    
    init(travelRepository: TravelRepository) {
        self.travelRepository = travelRepository
    }
    
    func getTravelData(completion: (() -> Void)?) {
        travelRepository.getReadTravelSchedules(userId: "1",
                                                completion: { [weak self] result in
            guard let self else { return }
            travelPlanHistoryData = result.travelSchedules.map { .init(travelId: $0.id,
                                                                       createdAt: String($0.createdAt.split(separator: "T").first ?? ""),
                                                                       chatTitle: $0.tripName) }
            completion?()
        })
    }
}
