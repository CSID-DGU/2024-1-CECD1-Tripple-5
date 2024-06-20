import UIKit

import SnapKit
import Then

final class AddPlanAlertView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubviews(iconImageView,
                                contentTextLabel,
                                okButton)
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(46)
        }
        
        contentTextLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(72)
        }
        okButton.snp.makeConstraints {
            $0.top.equalTo(contentTextLabel.snp.bottom).offset(60)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = .icAlert
        $0.contentMode = .scaleAspectFill
    }
    private let contentTextLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 16).font
        $0.textColor = .gray600
        $0.textAlignment = .center
        $0.text = "일정을 2개이상 선택 시 여행 일정 만들기 버튼을 눌러 여행 일정을 만들 수 있습니다.\n\n만들어진 여행 일정은 여행 일정 탭에 저장됩니다."
        $0.numberOfLines = 0
    }
    let okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = Pretendard.pretendardSemibold(size: 16).font
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.backgroundColor = .mainBlue
    }
}
