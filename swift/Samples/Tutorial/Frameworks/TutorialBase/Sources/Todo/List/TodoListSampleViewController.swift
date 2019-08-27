import TutorialViews


final class TodoListSampleViewController: UIViewController {
    let todoListView: TodoListView

    init() {
        todoListView = TodoListView(frame: .zero)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(todoListView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        todoListView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }
}
