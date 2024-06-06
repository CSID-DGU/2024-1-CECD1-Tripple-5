import UIKit

class TabbarController: UITabBarController {
    private var lastSelectVC: String = "homeVC"
    private var controllers: [UINavigationController] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, stepinTabbar.self)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        createTabs()
    }
    
    private func createTabs() {
        let pages: [TabbarType] = TabbarType.allCases
        controllers = pages.map {
            self.createTabNavigationController(of: $0)
        }
        self.configureTabBarController(with: controllers)
    }
    
    
    private func setBackground() {
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
    }
    
    class stepinTabbar: UITabBar {
        override func layoutSubviews() {
            super.layoutSubviews()
        }
        
        override open func sizeThatFits(_ size: CGSize) -> CGSize {
            super.sizeThatFits(size)
            
            guard let window = UIWindow.key else {
                return super.sizeThatFits(size)
            }
            
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = window.safeAreaInsets.bottom + AppConstants.tabbarHeight
            return sizeThatFits
        }
        
    }
    
    func currentPage() -> TabbarType? {
        return TabbarType(index: self.selectedIndex)
    }
    
    func selectPage(_ page: TabbarType) {
        self.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabbarType(index: index) else { return }
        self.selectedIndex = page.pageOrderNumber()
    }
    
    func createTabNavigationController(of page: TabbarType) -> UINavigationController {
        let viewController: UIViewController
        
        switch page {
        case .recommend:
            viewController = RecommendVC()
        case .chat:
            viewController = ChatVC()
        case .travelPlan:
            viewController = TravelPlanVC()
        case .profile:
            viewController = ProfileVC()
        }
        
        let tabNavigationController = UINavigationController(rootViewController: viewController)
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        
        return tabNavigationController
    }
    
    private func configureTabBarItem(of page: TabbarType) -> UITabBarItem {
        switch page {
        case .recommend:
            let item = UITabBarItem(
                title: "추천",
                image: .icHome,
                selectedImage: .icHomeActive
            )
            item.imageInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
            item.tag = page.pageOrderNumber()
            return item
        case .chat:
            let item = UITabBarItem(
                title: "채팅",
                image: .icChat,
                selectedImage: .icChatActive
            )
            item.tag = page.pageOrderNumber()
            return item
        case .travelPlan:
            let item = UITabBarItem(
                title: "여행일정",
                image: .icHistory,
                selectedImage: .icHistoryActive
            )
            item.imageInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
            item.tag = page.pageOrderNumber()
            return item
        case .profile:
            let item = UITabBarItem(
                title: "프로필",
                image: .icProfile,
                selectedImage: .icProfileActive
            )
            item.imageInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
            item.tag = page.pageOrderNumber()
            return item
        }
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.setViewControllers(tabViewControllers, animated: true)
        self.selectedIndex = TabbarType.chat.pageOrderNumber()
        self.viewSafeAreaInsetsDidChange()
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.mainBlue,
                                                                                 .font: Pretendard.pretendardSemibold(size: 12).font]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray400,
                                                                               .font: Pretendard.pretendardSemibold(size: 12).font]
        tabBarAppearance.stackedItemWidth = 50
        tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = .init(horizontal: 0, vertical: -6)
        tabBarAppearance.stackedLayoutAppearance.selected.titlePositionAdjustment = .init(horizontal: 0, vertical: -6)
        tabBarAppearance.stackedItemSpacing = 24
        tabBarAppearance.stackedItemPositioning = .centered
        tabBarAppearance.backgroundEffect = nil
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}

extension TabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        self.selectedViewController = viewController
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
