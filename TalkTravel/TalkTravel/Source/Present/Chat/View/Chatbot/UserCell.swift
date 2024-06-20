import UIKit

import SnapKit
import Then

final class UserCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUI() {
        self.contentView.backgroundColor = .gray100
    }
    
    func bindData(text: String) {
        chatTextLabel.text = text
    }
    
    private func setLayout() {
        self.contentView.addSubview(contentBackgroundView)
        
        contentBackgroundView.snp.makeConstraints {
            $0.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 80)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        contentBackgroundView.addSubview(chatTextLabel)
        chatTextLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
    private let contentBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        $0.clipsToBounds = true
    }
    
    let chatTextLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.numberOfLines = 0
    }
}
 
