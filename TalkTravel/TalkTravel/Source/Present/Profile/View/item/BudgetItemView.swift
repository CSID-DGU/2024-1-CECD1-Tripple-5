import UIKit

import SnapKit
import Then

final class BudgetItemView: UIView {
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLayout() {
        self.addSubviews(mainTitleLabel,
                         titleContentView,
                         sliderContentView)
        
        sliderContentView.addSubview(sliderContentStackView)
        
        sliderContentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            
        }
        
        titleContentView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview()
        }
        
        titleContentView.addArrangeSubviews(titleIconImageView, titleLabel)
        
        sliderContentView.snp.makeConstraints {
            $0.top.equalTo(titleContentView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        sliderContentStackView.addArrangeSubviews(hotelSliderView,
                                             foodExpenseSliderView,
                                             travelBudgetSliderView)
    
    }
    
    private let mainTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 16).font
        $0.textColor = .gray600
        $0.text = "총 예산"
    }
    private let titleContentView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    private let titleIconImageView = UIImageView().then {
        $0.image = .icWallet
        $0.contentMode = .scaleAspectFill
    }
    private let titleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 20).font
        $0.textColor = .gray700
    }
    
    private let sliderContentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    private let sliderContentStackView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 25
    }
    
    var hotelSliderView = CustomSlider(title: "숙소",
                                       bottomLeft: "10만원",
                                       bottomRight: "100만원")
    var foodExpenseSliderView = CustomSlider(title: "식비",
                                       bottomLeft: "10만원",
                                       bottomRight: "100만원")
    var travelBudgetSliderView = CustomSlider(title: "관광",
                                       bottomLeft: "10만원",
                                       bottomRight: "100만원")
}
