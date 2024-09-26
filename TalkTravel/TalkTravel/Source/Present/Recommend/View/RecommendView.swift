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
        self.backgroundColor = UIColor(red: 249.0 / 255.0,
                                       green: 249.0 / 255.0,
                                       blue: 249.0 / 255.0,
                                       alpha: 1.0)
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
        }
        scrollContentView.addArrangeSubviews(gotoChatButton,
                                             themePlaceCollectionViewHeader,
                                             themePlaceCollectionView,
                                             recommendPlaceCollectionViewHeader,
                                             recommendPlaceCollectionView)
        gotoChatButton.snp.makeConstraints {
            $0.height.equalTo(140)
        }
        scrollContentView.setCustomSpacing(30, after: gotoChatButton)
        
        themePlaceCollectionView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        scrollContentView.setCustomSpacing(15, after: themePlaceCollectionViewHeader)
        scrollContentView.setCustomSpacing(20, after: themePlaceCollectionView)
        
        recommendPlaceCollectionView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        
        scrollContentView.setCustomSpacing(15, after: recommendPlaceCollectionViewHeader)
        
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
                                                    collectionViewLayout: .init()).then {
        $0.tag = 0
        $0.showsHorizontalScrollIndicator = false
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 250,
                                height: 150)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        $0.register(RecommendPlaceCell.self,
                    forCellWithReuseIdentifier: RecommendPlaceCell.reuseIdentifier)
        $0.setCollectionViewLayout(layout, animated: false)
    }
    let recommendPlaceCollectionViewHeader = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 16).font
        $0.textColor = .black
        $0.text = "요즘 뜨는 테마 여행지"
    }
    let recommendPlaceCollectionView = UICollectionView(frame: .zero,
                                                        collectionViewLayout: .init()).then {
        $0.tag = 1
        $0.showsHorizontalScrollIndicator = false
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 250,
                                height: 150)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        $0.register(RecommendPlaceCell.self,
                    forCellWithReuseIdentifier: RecommendPlaceCell.reuseIdentifier)
        $0.setCollectionViewLayout(layout, animated: false)
    }
}

