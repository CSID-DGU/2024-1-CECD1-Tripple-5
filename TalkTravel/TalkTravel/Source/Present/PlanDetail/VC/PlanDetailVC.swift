import UIKit

final class PlanDetailVC: UIViewController {
    private var viewModel = PlanDetailViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = planDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        bindButtonAction()
    }
    
    private func setDelegate() {
        planDetailView.collectionView.dataSource = self
        planDetailView.collectionView.delegate = self
    }
    
    func bindNavigationTitle(title: String) {
        planDetailView.navigationView.setTitle(title: title)
    }
    
    func bindButtonAction() {
        self.planDetailView.navigationView.leftViewAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private var planDetailView = PlanDetailView()
}
extension PlanDetailVC: UICollectionViewDelegate { }
extension PlanDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } 
        if section == 1 {
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
            return cell
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
