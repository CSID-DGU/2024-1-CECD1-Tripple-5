import UIKit

import SnapKit
import Then
import Kingfisher

final class RecommendPlaceCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bindData(imagePath: String,
                  placeTitle: String,
                  placeLocale: String) {
        titleLabel.text = placeTitle
        placeLabel.text = placeLocale
        
        if let imageUrl = URL(string: imagePath) {
            imageView.kf.setImage(with: imageUrl)
        } else {
            imageView.backgroundColor = .gray300
        }
    }
    
    private func setLayout() {
        self.contentView.addSubviews(imageView)
        imageView.addSubviews(titleLabel,
                              placeContentView)
        placeContentView.addArrangeSubviews(placeIconImageView,
                                            placeLabel)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        placeContentView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(6)
        }
        
        self.imageView.addGradient(size: .init(width: 250,
                                               height: 150),
                                   colors: [UIColor.black.withAlphaComponent(0.7).cgColor,
                                            UIColor.clear.cgColor],
                                   startPoint: .bottomCenter,
                                   endPoint: .center)
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 14).font
        $0.textColor = .white
    }
    
    private let placeContentView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.spacing = 2
    }
    private let placeIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = .icLocation
    }
    private let placeLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 12).font
        $0.textColor = .mainYellow2
    }
}
