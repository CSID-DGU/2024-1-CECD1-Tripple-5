import UIKit

import RxSwift
import RxCocoa

final class SearchVC: UIViewController {
    var disposeBag = DisposeBag()
    private var viewModel: SearchViewModel = .init(placeRepository: .init())
    
    override func loadView() {
        super.loadView()
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        addButtonTarget()
        addOutputAction()
    }
    
    private func setDelegate() {
        self.searchView.searchResultTableView.dataSource = self
        self.searchView.searchResultTableView.delegate = self
    }
    
    private func addButtonTarget() {
        searchView.backButton.rx.tap.asObservable()
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        searchView.searchButton.rx.tap.asObservable()
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.viewModel.getPlaces(query: vc.searchView.textField.text ?? "")
            })
            .disposed(by: disposeBag)
    }
    
    private func addOutputAction() {
        viewModel.refreshRelay
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.searchView.searchResultTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private let searchView = SearchView()
}
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlaceDetailVC()
        vc.viewModel.placeId = self.viewModel.searchResults[indexPath.row].id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc,
                                                      animated: true)
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultItem.reuseIdentifier,
                                                       for: indexPath) as? SearchResultItem else { return UITableViewCell() }
        cell.bindData(title: viewModel.searchResults[indexPath.row].title,
                      location: viewModel.searchResults[indexPath.row].location,
                      imageUrl: viewModel.searchResults[indexPath.row].imageUrl)
        return cell
    }
}
