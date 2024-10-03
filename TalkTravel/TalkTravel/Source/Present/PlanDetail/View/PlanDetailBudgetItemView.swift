import UIKit

import SnapKit
import Then

final class PlanDetailBudgetItemView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    func bindData(data: PlanDetailBudgetItemData) {
        placeNameLabel.text = data.placeName
        budgetLabel.text = data.budget
    }
    
    private func setLayout() {
        self.addSubviews(placeNameLabel,
                         budgetLabel)
        
        placeNameLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        
        budgetLabel.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
        }
        
    }
    
    private let placeNameLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray600
        $0.textAlignment = .left
    }
    
    private let budgetLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 14).font
        $0.textColor = .gray600
    }
}
