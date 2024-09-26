import UIKit

import SnapKit
import Then

final class RecommendView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setConfig()
        setLayout()
    }
    
    private func setConfig() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        self.addSubviews(navigationView,
                         scrollView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
//            $0.height.greaterThanOrEqualTo(UIScreen.main.bounds.height)
        }
        scrollContentView.addArrangeSubviews(gotoChatButton,
                                             themePlaceCollectionViewHeader,
                                             themePlaceCollectionView,
                                             recommendPlaceCollectionViewHeader,
                                             recommendPlaceCollectionView)
        gotoChatButton.snp.makeConstraints {
            $0.height.equalTo(140)
        }
        
        themePlaceCollectionView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        
        recommendPlaceCollectionView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        
    }
    
    let navigationView = GlobalNavigationView().makeHomeNavigation()
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.contentInset = .init(top: 20,
                                left: 20,
                                bottom: 0,
                                right: 20)
    }
    let scrollContentView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    let gotoChatButton = GotoChatButton()
    
    
    let themePlaceCollectionViewHeader = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 16).font
        $0.textColor = .black
        $0.text = "요즘 뜨는 테마 여행지"
    }
    let themePlaceCollectionView = UICollectionView(frame: .zero,
                                                    collectionViewLayout: .init())
    let recommendPlaceCollectionViewHeader = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 16).font
        $0.textColor = .black
        $0.text = "요즘 뜨는 테마 여행지"
    }
    let recommendPlaceCollectionView = UICollectionView(frame: .zero,
                                                    collectionViewLayout: .init())
}

