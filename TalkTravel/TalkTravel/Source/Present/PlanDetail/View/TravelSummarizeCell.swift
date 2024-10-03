import UIKit
import MapKit

import SnapKit
import Then

final class TravelSummarizeCell: UICollectionViewCell {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.budgetContentView.removeAllSubViews()
        mapView.region = MKCoordinateRegion()
    }
    
    func bindData(data: PlanDetailSummaryData) {
        allPlanContentLabel.text = data.allPlan
        allBudgetContentLabel.text = data.allBudget
        
        setMap(location: data.allPlaceLocation)
        
        data.budgetDetail.forEach { [weak self] data in
            guard let self else { return }
            let itemView = PlanDetailBudgetItemView()
            itemView.bindData(data: data)
            budgetContentView.addArrangedSubview(itemView)
        }
    }
    
    private func setMap(location: [PlaceLocateData]) {
        guard let firstLocation = location.first else { return }
        let center = CLLocationCoordinate2D(latitude: firstLocation.lat,
                                            longitude: firstLocation.lon)
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
        
        self.cellContentView.addSubviews(mapView,
                                         allPlanTitleLabel,
                                         allPlanContentLabel,
                                         allBudgetTitleLabel,
                                         allBudgetContentLabel,
                                         budgetContentView,
                                         bottomLineView)

        mapView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(210)
        }
        
        allPlanTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(40)
            $0.leading.equalToSuperview()
        }
        
        allPlanContentLabel.snp.makeConstraints {
            $0.top.equalTo(allPlanTitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        allBudgetTitleLabel.snp.makeConstraints {
            $0.top.equalTo(allPlanContentLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview()
        }
        
        allBudgetContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(allBudgetTitleLabel)
            $0.trailing.equalToSuperview()
        }
        
        budgetContentView.snp.makeConstraints {
            $0.top.equalTo(allBudgetTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(budgetContentView.snp.bottom).offset(40)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    private let cellContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var mapView = MKMapView().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    
    private let allPlanTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 18).font
        $0.textColor = .gray800
        $0.text = "전체 일정"
    }
    
    private let allPlanContentLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray600
    }
    
    private let allBudgetTitleLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 18).font
        $0.textColor = .gray800
        $0.text = "총 평균 지출 비용"
    }
    
    private let allBudgetContentLabel = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 18).font
        $0.textColor = .gray800
    }
    
    private let budgetContentView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray200
    }
}
