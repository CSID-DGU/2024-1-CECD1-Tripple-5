import UIKit
import MapKit

import SnapKit
import Then
import Kingfisher

final class ReceivedCell: UITableViewCell {
    var _observerAdded: Bool?
    var _auth: Bool?
    var _appear: Bool?
    var location: ChatLocationData?
    var buttonActionCompletion: (() -> Void)?
    var urlLabelActionCompletion: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        addObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .gray100
    }
    
    @objc private func didAddPlanButtonTap() {
        addPlanButton.button.isSelected.toggle()
        self.contentView.layoutIfNeeded()
        guard let buttonActionCompletion else { return }
        buttonActionCompletion()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = true
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = false
    }
    
    @objc func willResignActive(){
        print("willResignActive")
    }
    
    @objc func didBecomeActive(){
        print("didBecomeActive")
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
        
        if let location = data.loacation {
            locationDetailLabel.isHidden = false
            locationDetailLabel.text = location
        } else {
            locationDetailLabel.isHidden = true
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
            addPlanButton.button.isSelected = isAddPlan
            print("buttonState", isAddPlan)
        } else {
            addPlanButton.isHidden = true
        }
        
        if let detailLocation = data.detailLocation {
            self.location = nil
            mapView.isHidden = false
            setMap(location: .init(lat: Double(detailLocation.lat) ?? 0,
                                   lon: Double(detailLocation.long) ?? 0))
        } else {
            mapView.isHidden = true
        }
    }
    
    private func setMap(location: PlaceLocateData) {
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
        self.contentView.addSubview(chatContentView)
        chatContentView.addSubview(chattingStackView)
        chatContentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.width.lessThanOrEqualTo(UIScreen.main.bounds.width)
        }
        
        chattingStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        chattingStackView.addArrangeSubviews(singleLabel,
                                             locationLabel,
                                             locationDetailLabel,
                                             linkLabel,
                                             detailLabel,
                                             placeImageView,
                                             mapView,
                                             addPlanButton)
        
        placeImageView.snp.makeConstraints {
            $0.height.equalTo(140)
        }
        mapView.snp.makeConstraints {
            $0.width.equalTo(288)
            $0.height.equalTo(140)
        }
    }
    
    @objc private func urlLabelTap() {
        guard let urlLabelActionCompletion else { return }
        urlLabelActionCompletion(linkLabel.text ?? "")
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
        $0.alignment = .fill
        $0.axis = .vertical
    }
    private let singleLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    private let locationLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    private let locationDetailLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    private lazy var linkLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(urlLabelTap)))
        $0.isUserInteractionEnabled = true
    }
    private let detailLabel = UILabel().then {
        $0.font = Pretendard.pretendardMedium(size: 14).font
        $0.textColor = .gray800
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    private let placeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
    }
    private lazy var mapView = MKMapView(frame: .init(origin: .zero, size: .init(width: 288, height: 140)))
        .then {
            $0.delegate = self
        }
    private lazy var addPlanButton = AddPlanButton().then {
        $0.button.addTarget(self,
                            action: #selector(didAddPlanButtonTap),
                            for: .touchUpInside)
    }
    
}

extension ReceivedCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let identifier = "custom_place"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            annotationView?.image = .icMap
        }
        
        return annotationView
    }
}
