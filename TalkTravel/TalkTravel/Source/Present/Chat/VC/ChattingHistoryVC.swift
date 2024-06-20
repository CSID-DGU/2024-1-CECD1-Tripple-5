import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ChattingHistoryVC: BaseVC {
    var viewModel = ChatbotHistoryViewModel()
    var selecteCompletion: ((String) -> Void)?
    var createNewChatCompletion: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindDataSource()
        setLayout()
        bindSelectItemAction()
        bindCreateNewChatAction()
        viewModel.getHistoryData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startExistAnimation()
    }
    
    private func setLayout() {
        self.view.addSubviews(dimView,
                              chattingHistoryView)
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        chattingHistoryView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(300)
        }
        chattingHistoryView.transform = .init(translationX: -UIScreen.main.bounds.width, y: 0)
    }
    
    private func startExistAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.chattingHistoryView.transform = .identity
            }
        }
    }
    
    private func endRemoveAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.chattingHistoryView.transform = .init(translationX: -UIScreen.main.bounds.width, y: 0)
            } completion: { _ in
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func dimViewTapped(_ sender: UITapGestureRecognizer) {
        endRemoveAnimation()
    }
    
    private func bindCreateNewChatAction() {
        self.chattingHistoryView.startNewChattingButton.rx.tap.asObservable()
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                guard let completion = vc.createNewChatCompletion else { return }
                completion()
                vc.endRemoveAnimation()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSelectItemAction() {
        self.chattingHistoryView.chattingHistoryTableView.rx.itemSelected.asObservable()
            .withUnretained(self)
            .bind(onNext: { (vc, indexPath) in
                if let identifier = vc.viewModel.datasource.itemIdentifier(for: indexPath) {
                    if let roomId = vc.viewModel.historyDataDict[identifier]?.roomId {
                        vc.selecteCompletion?(roomId)
                        vc.endRemoveAnimation()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func bindDataSource() {
        viewModel.datasource = UITableViewDiffableDataSource(tableView: chattingHistoryView.chattingHistoryTableView,
                                                             cellProvider: { (tableView, indexPath, identifier) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatbotHistoryCell.reuseIdentifier,
                                                           for: indexPath) as? ChatbotHistoryCell else {
                return UITableViewCell()
            }
            cell.bindCell(title: self.viewModel.historyDataDict[identifier]?.title ?? "")
            return cell
        })
    }
    
    private let chattingHistoryView = ChattingHistoryView()
    private lazy var dimView = UIView().then {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(dimViewTapped(_:))))
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .gray800.withAlphaComponent(0.2)
    }
    
}
