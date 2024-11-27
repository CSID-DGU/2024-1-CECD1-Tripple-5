import UIKit

import Kingfisher

final class PlaceDetailVC: UIViewController {
    var viewModel: PlaceDetailViewModel = .init(placeRepository: .init())
    
    override func loadView() {
        super.loadView()
        self.view = placeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAction()
        viewModel.getPlaceDetailData { [weak self] in
            guard let self else { return }
            self.setViewData()
        }
    }
    
    private func setButtonAction() {
        self.placeDetailView.navigationView.leftViewAction = { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setViewData() {
        guard let data = viewModel.viewData else { return }
        placeDetailView.navigationView.setTitle(title: data.placeTitle)
        
        if let imagePath = data.imagePath,
               let url = URL(string: imagePath) {
            placeDetailView.placeImageView.kf.setImage(with: url)
        } else {
            placeDetailView.placeImageView.image = .imgEmptyCell
        }
        
        placeDetailView.placeTitle.text = data.placeDescriptionTitle
        placeDetailView.placeDescription.text = data.placeDescription
        
        placeDetailView.locationTitle.text = data.locationTitle
        placeDetailView.setMap(location: .init(lat: data.lon,
                                               lon: data.lat))
    }
    
    private let placeDetailView = PlaceDetailView()
}
