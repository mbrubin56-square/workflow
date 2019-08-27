import WorkflowUI


/**
 Wrapper view controller for being hosted in a backstack. Handles updating the bar button items.
 */
final class ScreenWrapperViewController: UIViewController {
    let key: AnyHashable
    let screenType: Any.Type

    let contentViewController: ScreenViewController<AnyScreen>

    init(item: BackStackScreen.Item, registry: ViewRegistry) {
        self.key = item.key
        self.screenType = item.screenType
        self.contentViewController = registry.provideView(for: item.screen)

        super.init(nibName: nil, bundle: nil)

        update(barVisibility: item.barVisibility)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        contentViewController.view.frame = view.bounds
    }

    func update(item: BackStackScreen.Item) {
        contentViewController.update(screen: item.screen)
        update(barVisibility: item.barVisibility)
    }

    func matches(item: BackStackScreen.Item) -> Bool {
        return item.key == key
            && item.screenType == screenType
    }

    private func update(barVisibility: BackStackScreen.BarVisibility) {
        navigationItem.setHidesBackButton(true, animated: false)

        guard case .visible(let barContent) = barVisibility else {
            return
        }

        switch barContent.leftItem {
        case .none:
            if navigationItem.leftBarButtonItem != nil {
                navigationItem.setLeftBarButton(nil, animated: true)
            }

        case .button(let button):
            if let leftItem = navigationItem.leftBarButtonItem as? CallbackBarButtonItem {
                leftItem.update(with: button)
            } else {
                navigationItem.setLeftBarButton(CallbackBarButtonItem(button: button), animated: true)
            }

        }

        switch barContent.rightItem {
        case .none:
            if navigationItem.rightBarButtonItem != nil {
                navigationItem.setRightBarButton(nil, animated: true)
            }

        case .button(let button):
            if let rightItem = navigationItem.rightBarButtonItem as? CallbackBarButtonItem {
                rightItem.update(with: button)
            } else {
                navigationItem.setRightBarButton(CallbackBarButtonItem(button: button), animated: true)
            }
        }

        let title: String
        switch barContent.title {
        case .none:
            title = ""
        case .text(let text):
            title = text
        }
        navigationItem.title = title

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class CallbackBarButtonItem: UIBarButtonItem {
    var handler: () -> Void

    init(button: BackStackScreen.BarContent.Button) {
        self.handler = {}

        super.init()
        self.target = self
        self.action = #selector(onTapped)
        update(with: button)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with button: BackStackScreen.BarContent.Button) {

        switch button.content {

        case .text(let title):
            self.title = title

        case .icon(let image):
            self.image = image
        }

        self.handler = button.handler
    }

    @objc private func onTapped() {
        handler()
    }
}
