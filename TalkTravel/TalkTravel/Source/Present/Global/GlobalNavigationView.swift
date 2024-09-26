import UIKit
import SnapKit
import Then

final class GlobalNavigationView: UIView {
    var leftViewAction: (() -> Void)?
    var centerViewAction: (() -> Void)?
    var rightViewAction: (() -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        
    }
    
    @objc private func leftButtonAcition() {
        guard let leftViewAction else { return }
        leftViewAction()
    }
    
    @objc private func centerButtonAcition() {
        guard let centerViewAction else { return }
        centerViewAction()
    }
    
    @objc private func rightButtonAcition() {
        guard let rightViewAction else { return }
        rightViewAction()
    }
    
    func makeHomeNavigation() -> GlobalNavigationView {
        let leftIconImageView = UIImageView().then {
            $0.image = .imgLogo
            $0.contentMode = .scaleAspectFill
        }
        
        let searchButton = UIButton().then {
            $0.setImage(.icSearch, for: .normal)
            $0.addTarget(self,
                         action: #selector(rightButtonAcition),
                         for: .touchUpInside)
        }
        
        self.addSubviews(leftIconImageView,
                         searchButton)
        
        leftIconImageView.snp.makeConstraints {
            $0.width.equalTo(116)
            $0.height.equalTo(26)
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().offset(20)
        }
        
        searchButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(leftIconImageView)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        return self
    }
    
    func makeSearchNavigation() -> GlobalNavigationView {
        let backButton = UIButton().then {
            $0.setImage(.icBack, for: .normal)
            $0.addTarget(self,
                         action: #selector(leftButtonAcition),
                         for: .touchUpInside)
        }
        
        textField = UITextField().then {
            $0.textColor = .gray700
            $0.font = Pretendard.pretendardMedium(size: 16).font
            $0.placeholder = "검색어를 입력하세요"
        }
        
        let searchButton = UIButton().then {
            $0.setImage(.icSearch, for: .normal)
            $0.addTarget(self,
                         action: #selector(rightButtonAcition),
                         for: .touchUpInside)
        }
        
        guard let textField else { return self }
        self.addSubviews(backButton,
                         textField,
                         searchButton)
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(20)
        }
        
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(14)
            $0.trailing.equalTo(searchButton.snp.trailing).inset(14)
        }
        
        searchButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(backButton)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        return self
    }
    
    func makeBackbuttonTitleNavigaiton(title: String = "") -> GlobalNavigationView {
        let backButton = UIButton().then {
            $0.setImage(.icBack, for: .normal)
            $0.addTarget(self,
                         action: #selector(leftButtonAcition),
                         for: .touchUpInside)
        }
        let titleLabel = UILabel().then {
            $0.font = Pretendard.pretendardSemibold(size: 16).font
            $0.textColor = .gray700
            $0.text = title
            $0.textAlignment = .center
        }
       
        self.addSubviews(backButton,
                         titleLabel)
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return self
    }
    
    func makeTitleNavigaiton(title: String) -> GlobalNavigationView {
        let titleLabel = UILabel().then {
            $0.font = Pretendard.pretendardSemibold(size: 16).font
            $0.textColor = .gray700
            $0.text = title
            $0.textAlignment = .center
        }
       
        self.addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(14)
        }
        
        return self
    }
    var textField: UITextField?
}
