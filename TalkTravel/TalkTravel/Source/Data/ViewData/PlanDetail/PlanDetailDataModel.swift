struct PlanDetailDataModel {
    var summaryData: PlanDetailSummaryData
    var detailData: [PlanDetailItemData]
}

struct PlanDetailSummaryData {
    var allPlaceLocation: [PlaceLocateData]
    let allPlan: String
    let allBudget: String
    var budgetDetail: [PlanDetailBudgetItemData]
}

struct PlanDetailBudgetItemData {
    let placeName: String
    let budget: String
}

struct PlanDetailItemData {
    let placeName: String
    let meanBudget: String
    let openingTime: String
    let location: PlaceLocateData
}

struct PlaceLocateData {
    let lat: Double
    let lon: Double
}
