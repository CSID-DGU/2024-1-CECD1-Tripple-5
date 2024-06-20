import UIKit

import RxSwift
import RxCocoa

final class AddPlanAlertVC: UIViewController {
    var disposeBag: DisposeBag = .init()
    
    override func loadView() {
        super.loadView()
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addButtonAction()
    }
    
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    private func addButtonAction() {
        alertView.okButton.rx.tap.asObservable()
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private let alertView = AddPlanAlertView()
}
