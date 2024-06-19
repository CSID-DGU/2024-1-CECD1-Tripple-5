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
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(36)
        }
        
        chatbotTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = .imgChat
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
    }
    private let chatbotTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 16).font
        $0.textColor = .gray600
        $0.text = "AI 챗봇"
    }
}
