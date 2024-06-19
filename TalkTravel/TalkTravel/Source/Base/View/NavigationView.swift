import UIKit

import SnapKit

class NavigationView: UIView {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setBackgroundColor(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    func setNavigationLayout(height: CGFloat) -> NavigationView? {
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        
        return self
    }
    
    func setLeftView(view: UIView,
                     leftPadding: CGFloat,
                     size: CGSize) -> NavigationView? {
        leftView = view
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(leftPadding)
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
        }
        
        return self
    }
    
    func setCenterView(view: UIView) -> NavigationView? {
        centerView = view
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return self
    }
    
    func setRightView(view: UIView,
                      rightPadding: CGFloat,
                      size: CGSize) -> NavigationView? {
        rightView = view
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(rightPadding)
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
        }
        return self
    }
    
    
    private var leftView: UIView?
    private var centerView: UIView?
    private var rightView: UIView?
}
