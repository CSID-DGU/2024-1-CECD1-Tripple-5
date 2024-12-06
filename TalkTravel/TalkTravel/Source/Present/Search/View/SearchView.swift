import UIKit

import SnapKit
import Then

final class SearchView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    private func setLayout() {
        self.backgroundColor = .white
        self.addSubviews(searchBar,
                        searchResultTableView)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        self.searchBar.addSubviews(backButton,
                                   textField,
                                   searchButton)
        
        backButton.snp.makeConstraints {
            $0.top.leading.equalTo(15)
            $0.size.equalTo(24)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(12)
            $0.centerY.equalTo(backButton)
        }
        
        searchButton.snp.makeConstraints {
            $0.leading.equalTo(textField.snp.trailing).offset(12)
            $0.centerY.equalTo(backButton)
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(24)
        }
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    let searchBar = UIView().then {
        $0.backgroundColor = .clear
    }
    let backButton = UIButton().then {
        $0.setImage(.icBack, for: .normal)
    }
    let searchButton = UIButton().then {
        $0.setImage(.icSearch, for: .normal)
    }
    let textField = UITextField().then {
        $0.font = Pretendard.pretendardMedium(size: 16).font
        $0.textColor = .black
        $0.placeholder = "검색어를 입력하세요"
    }
    
    let searchResultTableView = UITableView(frame: .zero,
                                            style: .plain).then {
        $0.register(SearchResultItem.self,
                    forCellReuseIdentifier: SearchResultItem.reuseIdentifier)
        $0.estimatedRowHeight = 90
    }
}
