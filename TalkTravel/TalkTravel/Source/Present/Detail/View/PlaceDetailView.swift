import UIKit
import MapKit

import SnapKit
import Then

final class PlaceDetailView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setLayout()
    }
    
    func setMap(location: PlaceLocateData) {
        let center = CLLocationCoordinate2D(latitude: location.lat,
                                            longitude: location.lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.005,
                                    longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center,
                                        span: span)
        mapView.setRegion(region,
                          animated: false)
        createAnnotaion(location: location)
    }
    
    func createAnnotaion(location: PlaceLocateData) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat,
                                                       longitude: location.lon)
        mapView.addAnnotation(annotation)
    }
    
    private func setLayout() {
        self.addSubviews(navigationView,
                         scrollView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.greaterThanOrEqualTo(UIScreen.main.bounds.height)
        }
        
        placeContentView.addSubviews(placeTitle,
                                     placeDescription)
        
        placeTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        placeDescription.snp.makeConstraints {
            $0.top.equalTo(placeTitle.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        locationContentView.addSubviews(locationTitle,
                                        mapView)
        
        locationTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(locationTitle.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(210)
        }
        
        stackView.addArrangeSubviews(placeImageView,
                                     placeContentView,
                                     locationContentView)
        
        let borderView = UIView()
        borderView.backgroundColor = .gray200
        stackView.addArrangedSubview(borderView)
        
        borderView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
    
    let navigationView = GlobalNavigationView().makeBackbuttonTitleNavigaiton()
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
    }
    
    let placeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let placeContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let placeTitle = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 20).font
        $0.textColor = .gray800
        $0.numberOfLines = 0
    }
    let placeDescription = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray600
        $0.numberOfLines = 0
    }
    
    
    private let locationContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let locationTitle = UILabel().then {
        $0.font = Pretendard.pretendardSemibold(size: 18).font
        $0.textColor = .gray800
    }
    private lazy var mapView = MKMapView(frame: .init(origin: .zero,
                                                      size: .init(width: UIScreen.main.bounds.width - 40,
                                                                  height: 210))) .then {
        $0.delegate = self
    }
    
}
extension PlaceDetailView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let identifier = "custom_place2"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            annotationView?.image = .icMap
        }
        
        return annotationView
    }
}
