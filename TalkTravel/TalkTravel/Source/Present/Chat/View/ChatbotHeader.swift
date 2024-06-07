import UIKit

import SnapKit
import Then
import Kingfisher

class ChatbotHeader: UITableViewHeaderFooterView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    private func setLayout() {
        self.addSubviews(profileImageView, chatbotTitleLabel)
        
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        chatbotTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    private let chatbotTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 16).font
        $0.textColor = .gray600
    }
}
