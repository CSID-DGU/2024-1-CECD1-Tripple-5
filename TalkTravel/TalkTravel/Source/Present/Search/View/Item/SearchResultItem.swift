import UIKit

import SnapKit
import Then
import Kingfisher

final class SearchResultItem: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setLayout()
        setConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setConfig() {
        self.selectionStyle = .none
    }
    
    func bindData(title: String,
                  location: String,
                  imageUrl: String?) {
        if let imageUrl = imageUrl,
           let url = URL(string: imageUrl) {
            previewImageView.kf.setImage(with: url)
        } else {
            previewImageView.image = .imgEmptyCell
        }
        titleLabel.text = title
        locationLabel.text = location
    }
    
    private func setLayout() {
        self.contentView.addSubviews(previewImageView,
                                     titleLabel,
                                     locationIconImageView,
                                     locationLabel,
                                     bottomLineView)
        
        previewImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(15)
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(previewImageView.snp.top).offset(9)
            $0.leading.equalTo(previewImageView.snp.trailing).offset(15)
        }
        
        locationIconImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.size.equalTo(12)
        }
        
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIconImageView.snp.trailing).offset(2)
            $0.centerY.equalTo(locationIconImageView)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(previewImageView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    private let previewImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    private let titleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 16).font
        $0.textColor = .gray700
    }
    
    private let locationIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = .icLocationGray
    }
    private let locationLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 12).font
        $0.textColor = .gray500
    }
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray200
    }
}
