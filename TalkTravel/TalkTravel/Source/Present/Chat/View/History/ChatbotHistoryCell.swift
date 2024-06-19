import UIKit

import SnapKit
import Then

final class ChatbotHistoryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setConfigure()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bindCell(title: String) {
        historyTitleLabel.text = title
    }
    
    private func setConfigure() {
        self.selectionStyle = .none
    }
    
    private func setLayout() {
        self.contentView.addSubviews(iconImageView, 
                                     historyTitleLabel,
                                     bottomLineView)
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.size.equalTo(26)
        }
        
        historyTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(20)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = .icChatlog
        $0.contentMode = .scaleAspectFill
    }
    private let historyTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray700
    }
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray200
    }
}
