import UIKit

import RxSwift
import RxRelay
import RxCocoa

class RecommendVC: UIViewController {
    private var disposeBag: DisposeBag = .init()
    var viewModel = RecommendViewModel(recommendationRepository: .init(),
                                       placeRepository: .init())
    
    override func loadView() {
        super.loadView()
        self.view = recommendView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getRecommendationData()
        viewModel.getThemePlaceData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setDelegate()
        setBindingRelay()
        bindButtonAction()
    }
    
    private func setDelegate() {
        self.recommendView.themePlaceCollectionView.dataSource = self
        self.recommendView.themePlaceCollectionView.delegate = self
        self.recommendView.recommendPlaceCollectionView.dataSource = self
        self.recommendView.recommendPlaceCollectionView.delegate = self
    }
    
    private func setBindingRelay() {
        viewModel.recommendPlaceUpdateRelay
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.recommendView.recommendPlaceCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.themePlaceUpdateRelay
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.recommendView.themePlaceCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindButtonAction() {
        recommendView.gotoChatButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                                 action: #selector(goToChatButtonTapped)))
    }
    
    @objc
    private func goToChatButtonTapped() {
        NotificationCenter.default.post(name: .moveToChatSection, object: nil, userInfo: nil)
    }

    
    private var recommendView = RecommendView()
}
extension RecommendVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return viewModel.themePlaceDatas.count
        } else {
            return viewModel.recommendPlaceDatas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendPlaceCell.reuseIdentifier,
                                                                for: indexPath) as? RecommendPlaceCell else {
                return UICollectionViewCell()
            }
            cell.bindData(imagePath: viewModel.themePlaceDatas[indexPath.row].placeImagePath,
                          placeTitle: viewModel.themePlaceDatas[indexPath.row].placeTitle,
                          placeLocale: viewModel.themePlaceDatas[indexPath.row].localeTitle)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendPlaceCell.reuseIdentifier,
                                                                for: indexPath) as? RecommendPlaceCell else {
                return UICollectionViewCell()
            }
            cell.bindData(imagePath: viewModel.recommendPlaceDatas[indexPath.row].placeImagePath,
                          placeTitle: viewModel.recommendPlaceDatas[indexPath.row].placeTitle,
                          placeLocale: viewModel.recommendPlaceDatas[indexPath.row].localeTitle)
            return cell
        }
    }
}

extension RecommendVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            let vc = PlaceDetailVC()
            vc.viewModel.placeId = self.viewModel.themePlaceDatas[indexPath.row].placeId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc,
                                                          animated: true)
        } else {
            let vc = PlaceDetailVC()
            vc.viewModel.placeId = self.viewModel.recommendPlaceDatas[indexPath.row].placeId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc,
                                                          animated: true)
        }
    }
}
