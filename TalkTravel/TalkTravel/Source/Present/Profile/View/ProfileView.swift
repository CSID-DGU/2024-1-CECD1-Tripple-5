import UIKit

import SnapKit
import Then

final class ProfileView: UIView {
    
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
        self.addSubviews(navigtaionView,
                         scrollView)
        
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        navigtaionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigtaionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollContentView.addArrangeSubviews(selectBudgetTitleLabel,
                                             budgetSliderSectionItem,
                                             themeSectionItem)
        scrollContentView.setCustomSpacing(20, after: selectBudgetTitleLabel)
        scrollContentView.setCustomSpacing(20, after: budgetSliderSectionItem)
        
    }
    
    let navigtaionView = GlobalNavigationView().makeTitleNavigaiton(title: "프로필")
    let scrollView = UIScrollView().then {
        $0.contentInset = .init(top: 20,
                                left: 20,
                                bottom: 100,
                                right: 20)
    }
    let scrollContentView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .vertical
    }
    let selectBudgetTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 20).font
        $0.textColor = .gray800
        $0.text = "사용자님의\n여행 컨셉을 골라주세요"
        $0.numberOfLines = 0
    }
    let budgetSliderSectionItem = BudgetItemView()
    let themeSectionItem = TravelItemView()
    
    
}
