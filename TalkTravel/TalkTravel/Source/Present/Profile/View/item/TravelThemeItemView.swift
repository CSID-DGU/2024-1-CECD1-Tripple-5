import UIKit

import SnapKit
import Then

final class TravelThemeItemView: UIView {
    private var currentType: TravelThemeData?
    var isSelected: Bool = false {
        didSet {
            setState()
        }
    }
    
    var selectCompletion: ((TravelThemeData?) -> Void)?
    
    init() {
        super.init(frame: .zero)
        setState()
        setLayout()
        setConfig()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bindData(type: TravelThemeData) {
        self.currentType = type
        titleLabel.text = type.type.title
        self.isSelected = type.isSelected
    }
    
    private func addGesture() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(itemSelected)))
    }
    
    @objc
    private func itemSelected() {
        guard let selectCompletion else { return }
        selectCompletion(self.currentType)
        
        print(self.currentType)
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setState() {
        backgroundColor = isSelected ? .mainBlue : .gray100
        titleLabel.textColor = isSelected ? .white : .gray500
    }
    
    private func setConfig() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = isSelected ? .white : .gray500
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
    }
}
