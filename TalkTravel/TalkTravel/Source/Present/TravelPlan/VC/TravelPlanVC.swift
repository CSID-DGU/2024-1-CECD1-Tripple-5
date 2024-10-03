import UIKit

import RxSwift
import RxCocoa

class TravelPlanVC: UIViewController {
    private var disposeBag = DisposeBag()
    var viewModel = TravelPlanViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = travelPlanView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        travelPlanView.planHistoryCollectionView.dataSource = self
        
        bindCollectionViewAction()
    }
    
    func bindCollectionViewAction() {
        travelPlanView.planHistoryCollectionView.rx.itemSelected.asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                let planDetailView = PlanDetailVC()
                planDetailView.bindNavigationTitle(title: viewModel.travelPlanHistoryData[indexPath.row].chatTitle)
                planDetailView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(planDetailView, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private var travelPlanView = TravelPlanView()

}

extension TravelPlanVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.travelPlanHistoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TravelPlanCell.reuseIdentifier,
                                                            for: indexPath) as? TravelPlanCell else {
            return UICollectionViewCell()
        }
        
        cell.bindData(createdAt: viewModel.travelPlanHistoryData[indexPath.row].createdAt,
                      chattingTitle: viewModel.travelPlanHistoryData[indexPath.row].chatTitle)
        
        return cell
    }
    
}
