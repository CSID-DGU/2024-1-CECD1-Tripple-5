import UIKit

import SnapKit
import Then

final class TravelPlanCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfig()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bindData(createdAt: String,
                  chattingTitle: String) {
        self.createdAtLabel.text = createdAt
        self.chattingTitleLabel.text = chattingTitle
    }
    
    private func setConfig() {
        self.contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.contentView.addSubviews(createdAtLabel,
                                     chattingTitleLabel,
                                     iconImageView,
                                     bottomLineView)
        
        createdAtLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        chattingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(createdAtLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(iconImageView.snp.leading)
        }
        
        iconImageView.snp.makeConstraints {
            $0.centerY.equalTo(chattingTitleLabel)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(chattingTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    private let createdAtLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 14).font
        $0.textColor = .mainBlue
        $0.textAlignment = .left
    }
    
    private let chattingTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 16).font
        $0.textColor = .gray800
        $0.textAlignment = .left
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = .icRight
        $0.contentMode = .scaleAspectFill
    }
    
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray200
    }
}
