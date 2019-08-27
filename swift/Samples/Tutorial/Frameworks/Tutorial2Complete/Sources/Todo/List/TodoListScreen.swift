import Workflow
import WorkflowUI
import TutorialViews


struct TodoListScreen: Screen {
    // The titles of the todo items
    var todoTitles: [String]

    // Callback when a todo is selected
    var onTodoSelected: (Int) -> Void
}


final class TodoListViewController: ScreenViewController<TodoListScreen> {
    let todoListView: TodoListView

    required init(screen: TodoListScreen, viewRegistry: ViewRegistry) {
        self.todoListView = TodoListView(frame: .zero)
        super.init(screen: screen, viewRegistry: viewRegistry)
        update(with: screen)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(todoListView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        todoListView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }

    override func screenDidChange(from previousScreen: TodoListScreen) {
        update(with: screen)
    }

    private func update(with screen: TodoListScreen) {
        // Update the todoList on the view with what the screen provided:
        todoListView.todoList = screen.todoTitles
        todoListView.onTodoSelected = screen.onTodoSelected
    }

}


extension ViewRegistry {

    public mutating func registerTodoListScreen() {
        self.register(screenViewControllerType: TodoListViewController.self)
    }

}
