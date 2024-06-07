import UIKit

import SnapKit
import Then

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
    }
    
    private func bindDataSource() {
        viewModel.datasource = UITableViewDiffableDataSource(tableView: chattingView.chattingTableView,
                                                             cellProvider: { (tableView, indexPath, item) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedCell.reuseIdentifier,
                                                           for: indexPath) as? ReceivedCell else { return UITableViewCell()}
            cell.bindData(data: item)
            return cell
        })
    }
    
    private let chattingView = ChatbotView()
}
