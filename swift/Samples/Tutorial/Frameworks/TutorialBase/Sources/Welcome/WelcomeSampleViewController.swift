import TutorialViews


final class WelcomeSampleViewController: UIViewController {
    let welcomeView: WelcomeView

    init() {
        welcomeView = WelcomeView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(welcomeView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        welcomeView.frame = view.bounds
    }
}
