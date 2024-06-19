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
        setConfigure()
        viewModel.bindData()
        bindTextFieldAction()
        bindButtonAction()
    }
    
    private func setConfigure() {
//        self.chattingView.chattingTableView.tableHeaderView = ChatbotHeader(frame: .init(origin: .zero,
//                                                                                         size: .init(width: UIScreen.main.bounds.height, 
//                                                                                                     height: 56)))
//        self.chattingView.chattingTableView.sectionHeaderHeight = 56
//        self.chattingView.chattingTableView.header
        self.chattingView.chattingTableView.delegate = self
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
            .subscribe(onNext: { (vc, _) in
                if !vc.chattingView.inputTextField.sendButton.isSelected { return }
                vc.viewModel.addUserItem(text: vc.chattingView.inputTextField.text)
                vc.chattingView.inputTextField.clearTextField()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindButtonAction() {
        chattingView.historyButton.rx.tap.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                let sideSheetVC = ChattingHistoryVC() // Your side sheet view controller
                sideSheetVC.modalPresentationStyle = .overFullScreen
                sideSheetVC.modalTransitionStyle = .crossDissolve
                vc.present(sideSheetVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private let chattingView = ChatbotView()
}
extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatbotHeader.reuseIdentifier) as? ChatbotHeader else { return nil }
        return header
    }
}
