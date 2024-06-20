import UIKit

import SnapKit
import Then

final class AddPlanButton: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    private func setLayout() {
        self.addSubviews(button)
        
        button.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(110)
        }
    }
    
    let button = UIButton().then {
        $0.setImage(.icCheckDefault, for: .normal)
        $0.setImage(.icCheckActive, for: .selected)
        $0.imageView!.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        $0.setTitle("여행 일정 추가", for: .normal)
        $0.setTitle("여행 일정 추가", for: .selected)
        $0.titleLabel?.font = Pretendard.pretendardSemibold(size: 14).font
        $0.setTitleColor(.gray400, for: .normal)
        $0.setTitleColor(.mainBlue, for: .selected)
    }
}
