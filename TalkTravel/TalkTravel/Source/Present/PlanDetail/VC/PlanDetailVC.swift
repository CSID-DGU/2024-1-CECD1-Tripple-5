import UIKit

final class PlanDetailVC: UIViewController {
    var viewModel = PlanDetailViewModel(travelRepository: .init())
    
    private var planDetailView = PlanDetailView()
    
    override func loadView() {
        super.loadView()
        self.view = planDetailView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getDetailData(completion: { [weak self] in
            guard let self else { return }
            self.planDetailView.collectionView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        bindButtonAction()
        viewModel.getDetailData(completion: { [weak self] in
            guard let self else { return }
            self.planDetailView.collectionView.reloadData()
        })
    }
    
    private func setDelegate() {
        planDetailView.collectionView.dataSource = self
        planDetailView.collectionView.delegate = self
    }
    
    func bindNavigationTitle(title: String) {
        planDetailView.navigationView.setTitle(title: title)
    }
    
    private func bindButtonAction() {
        self.planDetailView.navigationView.leftViewAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: - UICollectionViewDelegate
extension PlanDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.section == 1, destinationIndexPath.section == 1 else { return }
        var items = viewModel.detailData.detailData
        let movingItem = items.remove(at: sourceIndexPath.item)
        items.insert(movingItem, at: destinationIndexPath.item)
        viewModel.detailData.detailData = items
    }
}

// MARK: - UICollectionViewDataSource
extension PlanDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return viewModel.detailData.detailData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TravelSummarizeCell.reuseIdentifier,
                                                                for: indexPath) as? TravelSummarizeCell else { return UICollectionViewCell() }
            cell.bindData(data: viewModel.detailData.summaryData)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TravelDetailCell.reuseIdentifier,
                                                                for: indexPath) as? TravelDetailCell else { return UICollectionViewCell() }
            cell.bindData(data: viewModel.detailData.detailData[indexPath.row], row: indexPath.row)
            
            cell.upButtonCompletion = {
                self.changeIndexToTop(index: indexPath)
            }
            
            cell.downButtonCompletion = {
                self.changeIndexToBottom(index: indexPath)
            }
            
            return cell
        }
    }
    
    func changeIndexToTop(index: IndexPath) {
        if index.row == 0 { return }
        else {
            let originData = viewModel.detailData.detailData[index.row]
            viewModel.detailData.detailData.remove(at: index.row)
            viewModel.detailData.detailData.insert(originData, at: max(index.row - 1, 0))
            
            let originLocationSummaryData = viewModel.detailData.summaryData.allPlaceLocation[index.row]
            let originLocationBudgetData = viewModel.detailData.summaryData.budgetDetail[index.row]
            
            viewModel.detailData.summaryData.allPlaceLocation.remove(at: index.row)
            viewModel.detailData.summaryData.budgetDetail.remove(at: index.row)
            
            viewModel.detailData.summaryData.allPlaceLocation.insert(originLocationSummaryData, at: max(index.row - 1, 0))
            viewModel.detailData.summaryData.budgetDetail.insert(originLocationBudgetData, at: max(index.row - 1, 0))
            
        }
        
        DispatchQueue.main.async {
            self.planDetailView.collectionView.reloadItems(at: [.init(row: index.row, section: index.section),
                                                                .init(row: index.row - 1, section: index.section)])
            self.planDetailView.collectionView.reloadSections(.init(integer: 0))
        }
    }
    
    func changeIndexToBottom(index: IndexPath) {
        if index.row == viewModel.detailData.detailData.count - 1 { return }
        else {
            let originData = viewModel.detailData.detailData[index.row]
            viewModel.detailData.detailData.remove(at: index.row)
            viewModel.detailData.detailData.insert(originData, at: min(index.row + 1, viewModel.detailData.detailData.count - 1))
            
            let originLocationSummaryData = viewModel.detailData.summaryData.allPlaceLocation[index.row]
            let originLocationBudgetData = viewModel.detailData.summaryData.budgetDetail[index.row]
            
            viewModel.detailData.summaryData.allPlaceLocation.remove(at: index.row)
            viewModel.detailData.summaryData.budgetDetail.remove(at: index.row)
            
            viewModel.detailData.summaryData.allPlaceLocation.insert(originLocationSummaryData, at: min(index.row + 1, viewModel.detailData.summaryData.allPlaceLocation.count - 1))
            viewModel.detailData.summaryData.budgetDetail.insert(originLocationBudgetData, at: min(index.row + 1, viewModel.detailData.summaryData.budgetDetail.count - 1))
        }
        
        DispatchQueue.main.async {
            self.planDetailView.collectionView.reloadItems(at: [.init(row: index.row, section: index.section),
                                                                .init(row: index.row + 1, section: index.section)])
            self.planDetailView.collectionView.reloadSections(.init(integer: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: PlanDetailCollectionHeaderView.reuseIdentifier,
                                                                               for: indexPath) as? PlanDetailCollectionHeaderView else { return UICollectionReusableView() }
        if indexPath.section == 0 {
            headerView.bindTitle(title: "여행지 요약")
        } else {
            headerView.bindTitle(title: "상세 정보")
        }
        return headerView
    }
}
