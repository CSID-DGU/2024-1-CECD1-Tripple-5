import UIKit

import SnapKit
import Then

final class TravelItemView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(){
        super.init(frame: .zero)
        setLayout()
    }
    
    func bindData(section1: [TravelThemeData],
                  section2: [TravelThemeData],
                  section3: [TravelThemeData]) {
        section1View.bindData(types: section1)
        section2View.bindData(types: section2)
        section3View.bindData(types: section3)
    }
    
    private func setLayout() {
        self.addSubviews(sectionHeaderLabel,
                         contentBackgroundView)
        sectionHeaderLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        contentBackgroundView.snp.makeConstraints {
            $0.top.equalTo(sectionHeaderLabel.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentBackgroundView.addSubviews(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        contentStackView.addArrangeSubviews(section1View,
                                            section2View,
                                            section3View)
        
    }
    
    private let sectionHeaderLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 16).font
        $0.textColor = .gray600
        $0.text = "여행 테마"
    }
    private let contentBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    
    private let contentStackView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 15
    }
    
    
    lazy var section1View = TravelThemeItemSection()
    lazy var section2View = TravelThemeItemSection()
    lazy var section3View = TravelThemeItemSection()
}
