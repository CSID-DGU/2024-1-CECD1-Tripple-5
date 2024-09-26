import UIKit

import SnapKit
import Then

final class GotoChatButton: UIView {
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLayout() {
        self.addSubviews(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(140)
        }
        backgroundView.addSubviews(topLabelContentView,
                         bottomLabelContentView,
                         sideView)
        let label1 = UILabel().then {
            $0.font = Pretendard.pretendardSemibold(size: 20).font
            $0.textColor = .white
            $0.text = "나에게 딱 맞는 "
        }
        let label1ICon = UIImageView().then {
            $0.image = .icHomeLight
            $0.contentMode = .scaleAspectFill
        }
        topLabelContentView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomLabelContentView.snp.top)
        }
        topLabelContentView.addArrangeSubviews(label1, label1ICon)
        
        let label2 = UILabel().then {
            $0.font = Pretendard.pretendardSemibold(size: 20).font
            $0.textColor = .white
            $0.text = "여행지 "
        }
        let label2ICon = UIImageView().then {
            $0.image = .icHomePlane
            $0.contentMode = .scaleAspectFill
        }
        let label3 = UILabel().then {
            $0.font = Pretendard.pretendardSemibold(size: 20).font
            $0.textColor = .white
            $0.text = " 찾으러 가기"
        }
        bottomLabelContentView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        bottomLabelContentView.addArrangeSubviews(label2, label2ICon, label3)
        
        sideView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.size.equalTo(60)
        }
        
        let arrowIamgeView = UIImageView().then {
            $0.image = .icArrow
            $0.contentMode = .scaleAspectFill
        }
        
        sideView.addSubview(arrowIamgeView)
        arrowIamgeView.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.center.equalToSuperview()
        }
        
    }
    private let backgroundView = UIView().then {
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    private let topLabelContentView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let bottomLabelContentView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let sideView = UIView().then {
        $0.backgroundColor = .mainYellow
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    
    
    
}
