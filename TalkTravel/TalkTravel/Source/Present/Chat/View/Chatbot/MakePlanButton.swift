import UIKit

import SnapKit
import Then


final class MakePlanButton: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(42)
        }
    }
    
    private let button = UIButton().then {
        $0.tintColor = .clear
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .white
        config.background.cornerRadius = 30
        config.image = .icPlus
        config.attributedTitle = AttributedString("여행 일정 만들기".setAttributedText(options: [.font: Pretendard.pretendardSemibold(size: 16).font,
                                                                         .foregroundColor: UIColor.mainBlue]))
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.contentInsets = .init(top: 14, leading: 15, bottom: 14, trailing: 15)
        $0.configuration = config
    }
}
