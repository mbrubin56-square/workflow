import WorkflowUI


extension ViewRegistry {
    public mutating func registerBackStackContainer() {
        self.register(screenViewControllerType: BackStackContainer.self)
    }
}


public final class BackStackContainer: ScreenViewController<BackStackScreen>, UINavigationControllerDelegate {
    private let navController: UINavigationController

    public required init(screen: BackStackScreen, viewRegistry: ViewRegistry) {
        self.navController = UINavigationController()

        super.init(screen: screen, viewRegistry: viewRegistry)

        update(with: screen)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        navController.delegate = self
        addChild(navController)
        view.addSubview(navController.view)
        navController.didMove(toParent: self)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        navController.view.frame = view.bounds
    }

    public override func screenDidChange(from previousScreen: BackStackScreen) {
        update(with: screen)
    }

    // MARK: - UINavigationControllerDelegate

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setNavigationBarVisibility(with: screen, animated: animated)
    }

    // MARK: - Private Methods

    private func update(with screen: BackStackScreen) {
        var existingViewControllers: [ScreenWrapperViewController] = self.navController.viewControllers as! [ScreenWrapperViewController]
        var updatedViewControllers: [ScreenWrapperViewController] = []

        for item in screen.items {
            if let idx = existingViewControllers.firstIndex(where: { viewController -> Bool in
                viewController.matches(item: item)
            }) {
                let existingViewController = existingViewControllers.remove(at: idx)
                existingViewController.update(item: item)
                updatedViewControllers.append(existingViewController)
            } else {
                updatedViewControllers.append(ScreenWrapperViewController(
                    item: item,
                    registry: viewRegistry))
            }

        }

        navController.setViewControllers(updatedViewControllers, animated: true)
    }

    private func setNavigationBarVisibility(with screen: BackStackScreen, animated: Bool) {
        guard let topScreen = screen.items.last else {
            return
        }

        let hidden: Bool

        switch topScreen.barVisibility {
        case .hidden:
            hidden = true

        case .visible:
            hidden = false
        }
        navController.setNavigationBarHidden(hidden, animated: animated)

    }
}
