import UIKit

import SnapKit
import Then

final class TravelThemeItemSection: UIView {
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bindData(types: [TravelThemeData]) {
        leftItem.bindData(type: types[0])
        rightItem.bindData(type: types[1])
    }
    
    private func setLayout() {
        self.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStackView.addArrangeSubviews(leftItem,
                                            rightItem)
        
        leftItem.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        rightItem.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    
    private let contentStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 11
    }
    
    lazy var leftItem = TravelThemeItemView()
    lazy var rightItem = TravelThemeItemView()
}
