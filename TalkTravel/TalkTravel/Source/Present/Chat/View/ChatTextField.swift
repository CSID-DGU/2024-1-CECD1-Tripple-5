import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

final class ChatTextField: UIView {
    private var disposeBag = DisposeBag()
    var text: String = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
        bindTextField()
    }
    
    private func bindTextField() {
        self.textField.rx.text.orEmpty.asObservable()
            .withUnretained(self)
            .bind(onNext: { (vc, text) in
                vc.text = text
                vc.setButtonState(text: text)
            })
            .disposed(by: disposeBag)
    }
    
    private func setButtonState(text: String) {
        sendButton.isSelected = text.count > 0
    }
    
    private func setUI() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        self.addSubviews(textFieldContentView,
                         sendButton)
        textFieldContentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        textFieldContentView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        sendButton.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.leading.equalTo(textFieldContentView.snp.trailing).offset(9)
            $0.trailing.equalToSuperview().inset(19)
            $0.top.bottom.equalToSuperview().inset(13)
        }
    }
    
    private let textFieldContentView = UIView().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    private let textField = UITextField().then {
        $0.backgroundColor = .clear
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray700
        $0.attributedPlaceholder = "질문을 입력해주세요".setAttributedText(options: [.font: Pretendard.pretendardMedium(size: 14).font,
                                                                  .foregroundColor: UIColor.gray400])
    }
    
    let sendButton = UIButton().then {
        $0.setImage(.icSendDefault, for: .normal)
        $0.setImage(.icSendActive, for: .selected)
    }
}
