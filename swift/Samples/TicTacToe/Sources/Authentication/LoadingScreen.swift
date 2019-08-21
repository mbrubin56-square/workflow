import WorkflowUI


struct LoadingScreen: Screen {

}


extension ViewRegistry {

    public mutating func registerLoadingScreen() {
        self.register(screenViewControllerType: LoadingScreenViewController.self)
    }
}

fileprivate final class LoadingScreenViewController: ScreenViewController<LoadingScreen> {
    let loadingLabel: UILabel

    required init(screen: LoadingScreen, viewRegistry: ViewRegistry) {
        self.loadingLabel = UILabel(frame: .zero)

        super.init(screen: screen, viewRegistry: viewRegistry)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingLabel.font = UIFont.boldSystemFont(ofSize: 44.0)
        loadingLabel.textColor = .black
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."

        view.addSubview(loadingLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        loadingLabel.frame = view.bounds
    }
}
