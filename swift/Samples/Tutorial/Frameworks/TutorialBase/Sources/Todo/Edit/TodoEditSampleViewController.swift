import TutorialViews


final class TodoEditSampleViewController: UIViewController {
    let todoEditView: TodoEditView

    init() {
        todoEditView = TodoEditView(frame: .zero)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(todoEditView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        todoEditView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }
}
