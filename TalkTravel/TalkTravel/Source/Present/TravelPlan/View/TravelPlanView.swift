import UIKit

import SnapKit
import Then

final class TravelPlanView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setConfig()
        setLayout()
    }
    
    private func setConfig() {
        self.backgroundColor = UIColor(red: 249.0 / 255.0,
                                       green: 249.0 / 255.0,
                                       blue: 249.0 / 255.0,
                                       alpha: 1.0)
    }
    
    private func setLayout() {
        self.addSubviews(navigationView,
                         planHistoryCollectionView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        planHistoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    let navigationView = GlobalNavigationView().makeTitleNavigaiton(title: "여행 일정")
    
    let planHistoryCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.register(TravelPlanCell.self,
                    forCellWithReuseIdentifier: TravelPlanCell.reuseIdentifier)
        $0.contentInset = .init(top: 20,
                                left: 20,
                                bottom: 0,
                                right: 20)
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width - 40,
                                         height: 74)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        $0.setCollectionViewLayout(layout, 
                                   animated: false)
        $0.alwaysBounceVertical = true
    }
}
