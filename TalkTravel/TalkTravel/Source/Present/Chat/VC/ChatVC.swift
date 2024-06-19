import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ChatVC: BaseVC {
    var viewModel = ChatViewModel()
    
    override func loadView() {
        super.loadView()
        view = chattingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindDataSource()
        viewModel.bindData()
        bindTextFieldAction()
    }
    
    private func bindDataSource() {
        viewModel.datasource = UITableViewDiffableDataSource(tableView: chattingView.chattingTableView,
                                                             cellProvider: { (tableView, indexPath, item) in
            if item.isUserCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier,
                                                               for: indexPath) as? UserCell else { return UITableViewCell()}
                cell.bindData(text: item.singleText ?? "")
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedCell.reuseIdentifier,
                                                               for: indexPath) as? ReceivedCell else { return UITableViewCell()}
                cell.bindData(data: item)
                return cell
            }
        })
    }
    
    private func bindTextFieldAction() {
        chattingView.inputTextField.sendButton.rx.tap.asObservable()
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.viewModel.addUserItem(text: vc.chattingView.inputTextField.text)
            })
            .disposed(by: disposeBag)
    }
    
    private let chattingView = ChatbotView()
}
