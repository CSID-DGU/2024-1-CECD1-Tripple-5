import UIKit

import SnapKit
import Then
import Kingfisher
import KakaoMapsSDK

final class ReceivedCell: UITableViewCell {
    var mapController: KMController?
    var _observerAdded: Bool?
    var _auth: Bool?
    var _appear: Bool?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        prepareMapView()
        addViews()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .gray100
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
//        mapController?.stopRendering()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }
    
    @objc func didBecomeActive(){
        print("didBecomeActive")
//        mapController?.startRendering() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
    func createLabelLayer() {
        let view = mapController?.getView("mapView") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", 
                                            competitionType: .none,
                                            competitionUnit: .symbolFirst,
                                            orderType: .rank,
                                            zOrder: 10)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createPoiStyle() {
        let view = mapController?.getView("mapView") as! KakaoMap
        let manager = view.getLabelManager()
        let iconStyle1 = PoiIconStyle(symbol: .icMap, anchorPoint: .init(x: 0.0, y: 0.5), badges: [])

        let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
            PerLevelPoiStyle(iconStyle: iconStyle1, level: 5)
        ])
        manager.addPoiStyle(poiStyle)
    }
    
    func createPois() {
        if let view = mapController?.getView("mapView") as? KakaoMap {
            let manager = view.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "PoiLayer")
            let poiOption = PoiOptions(styleID: "PerLevelStyle", poiID: "poi1")
            poiOption.rank = 0
            let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
            poi1?.show()
        }
    }
    
    private func prepareMapView() {
        mapController = KMController(viewContainer: mapView)
        mapController!.delegate = self
        mapController?.prepareEngine()
        mapController?.activateEngine()
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
    private let mapView = KMViewContainer(frame: .init(origin: .zero, size: .init(width: 288, height: 140)))
    private let addPlanButton = UIButton().then {
        $0.setImage(.icCheckDefault, for: .normal)
        $0.setImage(.icCheckActive, for: .normal)
        $0.setTitle("여행 일정 추가", for: .normal)
    }
    
}
extension ReceivedCell: MapControllerDelegate {
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = .init(viewName: "mapView", defaultPosition: defaultPosition)
        mapController?.addView(mapviewInfo)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.createLabelLayer()
            self.createPoiStyle()
            self.createPois()
        }
    }
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapView") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("에러", errorCode, desc)
    }
}
