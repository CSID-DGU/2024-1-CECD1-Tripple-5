import UIKit
import Lottie
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    
    func showLoadingIndicator() {
        if let count = (self.rootViewController as! UINavigationController).topViewController?.view.subviews.count,
           count <= 2 {
            DispatchQueue.main.async {
                let loadingIndicator = LottieAnimationView(name: "loadingLottie")
                loadingIndicator.tag = 99
                let backgroundView = UIView().then {
                    $0.tag = 99
                    $0.backgroundColor = .black.withAlphaComponent(0.2)
                }
                
                (self.rootViewController as! UINavigationController).topViewController?.view.addSubviews(backgroundView, loadingIndicator)
                
                backgroundView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                
                loadingIndicator.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.size.equalTo(48)
                }
                loadingIndicator.loopMode = .loop
                loadingIndicator.play()
            }
        }
    }
    
    func removeLoadingIndicator() {
            DispatchQueue.main.async {
                (self.rootViewController as! UINavigationController).topViewController?.view.subviews.forEach {
                    if $0.tag == 99 {
                        $0.removeFromSuperview()
                    }
                }
            }
        }
    
}
