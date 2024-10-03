import UIKit

import SnapKit
import Then

final class PlanDetailView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setLayout()
        setConfig()
    }
    
    private func setConfig() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        self.addSubviews(navigationView,
                        collectionView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    var navigationView = GlobalNavigationView().makeBackbuttonTitleNavigaiton(title: "")
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(TravelSummarizeCell.self,
                    forCellWithReuseIdentifier: TravelSummarizeCell.reuseIdentifier)
        $0.register(TravelDetailCell.self,
                    forCellWithReuseIdentifier: TravelDetailCell.reuseIdentifier)
        $0.register(PlanDetailCollectionHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: PlanDetailCollectionHeaderView.reuseIdentifier)
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width - 40,
                                           height: 70)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.setCollectionViewLayout(layout, animated: false)
        $0.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
}
