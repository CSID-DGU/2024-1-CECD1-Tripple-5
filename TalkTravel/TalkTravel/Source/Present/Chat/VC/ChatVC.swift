import UIKit

import SnapKit
import Then
import RxSwift

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
        tableViewMoveToBottom()
        addAlertAction()
    }
    
    private func setConfigure() {
        self.chattingView.chattingTableView.delegate = self
    }
    
    private func bindDataSource() {
        viewModel.datasource = UITableViewDiffableDataSource(tableView: chattingView.chattingTableView,
                                                             cellProvider: { (tableView, indexPath, identifier) in
            guard let item = self.viewModel.chatDataDict[identifier] else { return UITableViewCell() }
            if item.isUserCell {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier,
//                                                               for: indexPath) as? UserCell else { return UITableViewCell()}
                let cell = UserCell(style: .default, reuseIdentifier: nil)
                cell.bindData(text: item.singleText ?? "")
                return cell
            } else {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedCell.reuseIdentifier,
//                                                               for: indexPath) as? ReceivedCell else { return UITableViewCell()}
                let cell = ReceivedCell(style: .default, reuseIdentifier: nil)
                cell.bindData(data: item)
                
                print(item.singleText)
                cell.urlLabelActionCompletion = { [weak self] _ in
                    guard let self else { return }
                    guard let newUrl = URL(string: self.decodeKakaoLink(viewModel.chatDataDict[identifier]?.link ?? "")) else { return }
                    let webVC = WebVC()
                    webVC.url = newUrl
                    self.present(webVC, animated: true)
                }
                cell.buttonActionCompletion = { [weak self] in
                    guard let self else { return }
                    let newDataFlag = !(self.viewModel.chatData.chatBotItem[indexPath.row].isAddPlan ?? false)
                    let newDictFlag = !(self.viewModel.chatDataDict[identifier]?.isAddPlan ?? false)
                    self.viewModel.chatDataDict[identifier]?.isAddPlan = newDictFlag
                    self.viewModel.chatData.chatBotItem[indexPath.row].isAddPlan = newDataFlag
                    self.viewModel.convertData()
                    self.viewModel.countAddPlanNumber()
                    
                    if let value = try? viewModel.isFirstSelectBehaviorRelay.value() {
                        if !value {
                            viewModel.isFirstSelectBehaviorRelay.onNext(true)
                        }
                    }
                }
                return cell
            }
        })
    }
    
    func decodeKakaoLink(_ encodedLink: String) -> String {
        var decodedLink = encodedLink
        decodedLink = decodedLink.replacingOccurrences(of: "link: ", with: "")
//        if let range = decodedLink.range(of: "link: ") {
//            decodedLink.removeSubrange(range)
//        }
//        decodedLink = decodedLink.replacingOccurrences(of: "%3A", with: "::")
        
        return decodedLink
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
                
                
                sideSheetVC.createNewChatCompletion = { [weak self] in
                    guard let self else { return }
                    self.viewModel.resetData(roomId: "")
                    viewModel.bindData()
                }
                
                sideSheetVC.selecteCompletion = { [weak self] roomId in
                    guard let self else { return }
                    self.viewModel.resetData(roomId: roomId)
                    self.viewModel.getChatHistoryData()
                    viewModel.bindData()
                }
                
                
                
            })
            .disposed(by: disposeBag)
    }
    
    private func tableViewMoveToBottom() {
        viewModel.updateChatData
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.chattingView.chattingTableView.setContentOffset(.init(x: .zero,
                                                                               y: self.chattingView.chattingTableView.contentSize.height - self.chattingView.chattingTableView.bounds.height),
                                                                         animated: true)
                    self.chattingView.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addAlertAction() {
        viewModel.isFirstSelectBehaviorRelay
            .withUnretained(self)
            .bind(onNext: { (vc, state) in
                if state {
                    let alertVC = AddPlanAlertVC()
                    alertVC.modalTransitionStyle = .crossDissolve
                    alertVC.modalPresentationStyle = .overFullScreen
                    vc.present(alertVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.addPlanCountRelay
            .withUnretained(self)
            .bind(onNext: { (vc, count) in
                if count >= 2 {
                    vc.chattingView.makePlanButton.isHidden = false
                } else {
                    vc.chattingView.makePlanButton.isHidden = true
                }
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
