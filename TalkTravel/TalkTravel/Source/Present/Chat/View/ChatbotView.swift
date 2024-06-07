import UIKit

import SnapKit
import Then

final class ChatbotView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    func setUI() {
        self.backgroundColor = .gray100
    }
    
    func setLayout() {
        guard let navigationView else { return }
        addSubviews(navigationView, chattingTableView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        chattingTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    
    let historyButton = UIButton().then {
        $0.setImage(.icMenu, for: .normal)
    }
    lazy var navigationView = NavigationView()
        .setNavigationLayout(height: 54)?
        .setLeftView(view: historyButton,
                      leftPadding: 17,
                      size: CGSize(width: 24, height: 24))
    
    let chattingTableView = UITableView(frame: .zero,
                                                     style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(ReceivedCell.self,
                    forCellReuseIdentifier: ReceivedCell.reuseIdentifier)
        $0.register(ChatbotHeader.self,
                    forHeaderFooterViewReuseIdentifier: ChatbotHeader.reuseIdentifier)
    }
    
}
