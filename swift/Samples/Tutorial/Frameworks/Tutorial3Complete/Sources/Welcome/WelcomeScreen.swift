import Workflow
import WorkflowUI
import TutorialViews


struct WelcomeScreen: Screen {
    /// The current name that has been entered.
    var name: String
    /// Callback when the name changes in the UI.
    var onNameChanged: (String) -> Void
    /// Callback when the login button is tapped.
    var onLoginTapped: () -> Void
}


final class WelcomeViewController: ScreenViewController<WelcomeScreen> {

    var welcomeView: WelcomeView

    required init(screen: WelcomeScreen, viewRegistry: ViewRegistry) {
        self.welcomeView = WelcomeView(frame: .zero)
        super.init(screen: screen, viewRegistry: viewRegistry)
        update(with: screen)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(welcomeView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        welcomeView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }

    override func screenDidChange(from previousScreen: WelcomeScreen) {
        update(with: screen)
    }

    private func update(with screen: WelcomeScreen) {
        /// Update UI
        welcomeView.name = screen.name
        welcomeView.onNameChanged = screen.onNameChanged
        welcomeView.onLoginTapped = screen.onLoginTapped
    }

}


extension ViewRegistry {

    public mutating func registerWelcomeScreen() {
        self.register(screenViewControllerType: WelcomeViewController.self)
    }

}
