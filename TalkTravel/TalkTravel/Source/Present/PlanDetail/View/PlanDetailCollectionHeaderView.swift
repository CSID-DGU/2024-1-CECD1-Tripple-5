import UIKit

import SnapKit
import Then

final class PlanDetailCollectionHeaderView: UICollectionReusableView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
        }
    }
    
    func bindTitle(title: String) {
        titleLabel.text = title
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 20).font
        $0.textColor = .gray800
    }
}
