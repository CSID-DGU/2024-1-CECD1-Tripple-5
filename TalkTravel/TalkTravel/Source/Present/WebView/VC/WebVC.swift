import UIKit
import WebKit

import SnapKit
import Then

class WebVC: BaseVC {
    var webView: WKWebView!
    var url: URL?
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUrl()
    }
    
    func setUrl() {
        if let url = self.url {
            print(url)
            print(url.absoluteString)
            self.webView.load(URLRequest(url: url))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension WebVC: WKUIDelegate {
}
extension WebVC: WKNavigationDelegate {
}
