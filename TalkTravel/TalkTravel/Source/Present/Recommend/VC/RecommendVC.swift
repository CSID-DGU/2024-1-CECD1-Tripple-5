import UIKit

class RecommendVC: UIViewController {
    var viewModel = RecommendViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = recommendView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setDelegate()
    }
    
    private func setDelegate() {
        self.recommendView.themePlaceCollectionView.dataSource = self
        self.recommendView.recommendPlaceCollectionView.dataSource = self
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
