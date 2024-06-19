import UIKit

import SnapKit
import Then

final class ChattingHistoryView: UIView {
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
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(300)
        }
        
        contentView.addSubviews(startNewChattingButton,
                                historyTableViewTitleLabel,
                                chattingHistoryTableView)
        
        startNewChattingButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        historyTableViewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(startNewChattingButton.snp.bottom).offset(30)
            $0.leading.equalTo(startNewChattingButton.snp.leading)
        }
        
        chattingHistoryTableView.snp.makeConstraints {
            $0.top.equalTo(historyTableViewTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    let startNewChattingButton = UIButton().then {
        $0.tintColor = .clear
        var config = UIButton.Configuration.plain()
        config.image = .icChatPlus
        config.attributedTitle = AttributedString("새로운 채팅 시작하기".setAttributedText(options: [.font: Pretendard.pretendardMedium(size: 14).font,
                                                                           .foregroundColor: UIColor.gray800]))
        config.imagePadding = 12
        config.contentInsets = .init(top: 22, leading: 20, bottom: 22, trailing: 88)
        config.background.backgroundColor = .mainYellow
        config.background.cornerRadius = 30
        $0.configuration = config
    }
    let historyTableViewTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 16).font
        $0.text = "대화 내역"
        $0.textColor = .gray600
    }
    let chattingHistoryTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(ChatbotHistoryCell.self,
                    forCellReuseIdentifier: ChatbotHistoryCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
}
