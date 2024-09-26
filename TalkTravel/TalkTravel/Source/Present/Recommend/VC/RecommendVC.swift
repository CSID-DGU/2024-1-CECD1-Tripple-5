import UIKit

class RecommendVC: UIViewController {
    
    override func loadView() {
        super.loadView()
        self.view = recommendView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    private var recommendView = RecommendView()
}
