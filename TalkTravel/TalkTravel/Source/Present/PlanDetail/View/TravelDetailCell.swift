import UIKit
import MapKit

import SnapKit
import Then


final class TravelDetailCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mapView.region = MKCoordinateRegion()
    }
    
    func bindData(data: PlanDetailItemData,
                  row: Int) {
        titleLabel.text =  "\(row + 1). " + data.placeName
        budgetContentLabel.text = data.meanBudget
        openScheduleContentLabel.text = data.openingTime
        
        setMap(location: data.location)
    }
    
    private func setMap(location: PlaceLocateData) {
        let center = CLLocationCoordinate2D(latitude: location.lat,
                                            longitude: location.lon)
        let span = MKCoordinateSpan(latitudeDelta: 1.0,
                                    longitudeDelta: 1.0)
        let region = MKCoordinateRegion(center: center,
                                        span: span)
        mapView.setRegion(region,
                          animated: false)
    }
    
    private func setLayout() {
        self.contentView.addSubview(cellContentView)
        cellContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        cellContentView.addSubviews(titleLabel,
                                    mapView,
                                    budgetTitleLabel,
                                    budgetContentLabel,
                                    openScheduleTitleLabel,
                                    openScheduleContentLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(210)
        }
        
        budgetTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        budgetContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(budgetTitleLabel)
            $0.trailing.equalToSuperview()
        }
        
        openScheduleTitleLabel.snp.makeConstraints {
            $0.top.equalTo(budgetTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        openScheduleContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(openScheduleTitleLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
        
    }
    
    private let cellContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 18).font
        $0.textColor = .gray700
    }
    
    private lazy var mapView = MKMapView().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    
    private let budgetTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray600
        $0.text = "평균 지출 예산"
    }
    
    private let budgetContentLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 14).font
        $0.textColor = .gray600
    }
    
    private let openScheduleTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray600
        $0.text = "운영 시간"
    }
    
    private let openScheduleContentLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 14).font
        $0.textColor = .gray600
    }
}
