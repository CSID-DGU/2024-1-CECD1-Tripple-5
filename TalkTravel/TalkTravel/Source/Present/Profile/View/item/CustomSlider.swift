import UIKit

import SnapKit
import Then

final class CustomSlider: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(title: String,
         bottomLeft: String,
         bottomRight: String) {
        super.init(frame: .zero)
        setLayout()
        
        titleLabel.text = title
        bottomLeftLabel.text = bottomLeft
        bottomRightLabel.text = bottomRight
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel,
                         bottomLeftLabel,
                         bottomRightLabel,
                         slider)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        slider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        bottomLeftLabel.snp.makeConstraints {
            $0.top.equalTo(slider.snp.bottom).offset(3)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bottomRightLabel.snp.makeConstraints {
            $0.top.equalTo(slider.snp.bottom).offset(3)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 16).font
        $0.textColor = .gray700
    }
    
    private let bottomLeftLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 12).font
        $0.textColor = .gray500
    }
    
    private let bottomRightLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 12).font
        $0.textColor = .gray500
    }
    
    let slider = UISlider().then {
        $0.minimumTrackTintColor = .mainBlue
        $0.maximumTrackTintColor = .gray300
        $0.value = 0.5
    }
}
