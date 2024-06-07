import UIKit

import SnapKit
import Then
import Kingfisher

final class ReceivedCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .gray100
    }
    
    func bindData(data: ChattingCellItemData) {
        if let singleText = data.singleText {
            singleLabel.isHidden = false
            singleLabel.text = singleText
        } else {
            singleLabel.isHidden = true
        }
        
        if let placeName = data.placeName {
            locationLabel.isHidden = false
            locationLabel.text = placeName
        } else {
            locationLabel.isHidden = true
        }
        
        if let link = data.link {
            linkLabel.isHidden = false
            linkLabel.text = link
        } else {
            linkLabel.isHidden = true
        }
        
        if let detail = data.detail {
            detailLabel.isHidden = false
            detailLabel.text = detail
        } else {
            detailLabel.isHidden = true
        }
        
        if let placeImagePath = data.placeImagePath,
           let url = URL(string: placeImagePath){
            placeImageView.isHidden = false
            placeImageView.kf.setImage(with: url)
        } else {
            placeImageView.isHidden = true
        }
        
        if let isAddPlan = data.isAddPlan {
            addPlanButton.isHidden = false
            addPlanButton.isSelected = isAddPlan
        } else {
            addPlanButton.isHidden = true
        }
    }
    
    private func setLayout() {
        self.contentView.addSubview(chatContentView)
        chatContentView.addSubview(chattingStackView)
        chatContentView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.lessThanOrEqualTo(UIScreen.main.bounds.width)
        }
        
        chattingStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        chattingStackView.addArrangeSubviews(singleLabel,
                                             locationLabel,
                                             linkLabel,
                                             detailLabel,
                                             placeImageView,
                                             addPlanButton)
        
        placeImageView.snp.makeConstraints {
            $0.height.equalTo(140)
        }
    }
    
    private let chatContentView = UIView().then {
        $0.backgroundColor = .mainYellow
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        $0.clipsToBounds = true
    }
    
    private let chattingStackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 6
        $0.alignment = .center
        $0.axis = .vertical
    }
    private let singleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.numberOfLines = 0
    }
    private let locationLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.numberOfLines = 0
    }
    private let linkLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.numberOfLines = 0
    }
    private let detailLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.numberOfLines = 0
    }
    private let placeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
    }
    private let addPlanButton = UIButton().then {
        $0.setImage(.icCheckDefault, for: .normal)
        $0.setImage(.icCheckActive, for: .normal)
        $0.setTitle("여행 일정 추가", for: .normal)
    }

}
