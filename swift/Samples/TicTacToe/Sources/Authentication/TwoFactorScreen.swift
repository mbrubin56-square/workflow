import WorkflowUI


struct TwoFactorScreen: Screen {
    var title: String
    var onLoginTapped: (String) -> Void
}


extension ViewRegistry {

    public mutating func registerTwoFactorScreen() {
        self.register(screenViewControllerType: TwoFactorViewController.self)
    }
}


fileprivate final class TwoFactorViewController: ScreenViewController<TwoFactorScreen> {
    let titleLabel: UILabel
    let twoFactorField: UITextField
    let button: UIButton

    required init(screen: TwoFactorScreen, viewRegistry: ViewRegistry) {
        self.titleLabel = UILabel(frame: .zero)
        self.twoFactorField = UITextField(frame: .zero)
        self.button = UIButton(frame: .zero)

        super.init(screen: screen, viewRegistry: viewRegistry)

        update(with: screen)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.textAlignment = .center

        twoFactorField.placeholder = "one time token"
        twoFactorField.backgroundColor = UIColor(white: 0.92, alpha: 1.0)

        button.backgroundColor = UIColor(red: 41/255, green: 150/255, blue: 204/255, alpha: 1.0)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)

        view.addSubview(titleLabel)
        view.addSubview(twoFactorField)
        view.addSubview(button)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let inset: CGFloat = 12.0
        let height: CGFloat = 44.0

        var yOffset = (view.bounds.size.height - (2 * height + inset)) / 2.0

        titleLabel.frame = CGRect(
            x: view.bounds.origin.x,
            y: view.bounds.origin.y,
            width: view.bounds.size.width,
            height: yOffset)

        twoFactorField.frame = CGRect(
            x: view.bounds.origin.x,
            y: yOffset,
            width: view.bounds.size.width,
            height: height)
            .insetBy(dx: inset, dy: 0.0)

        yOffset += height + inset

        button.frame = CGRect(
            x: view.bounds.origin.x,
            y: yOffset,
            width: view.bounds.size.width,
            height: height)
            .insetBy(dx: inset, dy: 0.0)
    }

    override func screenDidChange(from previousScreen: TwoFactorScreen) {
        update(with: screen)
    }

    private func update(with screen: TwoFactorScreen) {
        titleLabel.text = screen.title
    }

    @objc private func buttonTapped(sender: UIButton) {
        guard let twoFactorCode = twoFactorField.text else {
            return
        }
        screen.onLoginTapped(twoFactorCode)
    }
}
