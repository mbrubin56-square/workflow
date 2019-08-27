import Workflow
import WorkflowUI
import TutorialViews


struct TodoEditScreen: Screen {
    // The title of this todo item.
    var title: String
    // The contents, or "note" of the todo.
    var note: String

    // Callback for when the title or note changes
    var onTitleChanged: (String) -> Void
    var onNoteChanged: (String) -> Void
}


final class TodoEditViewController: ScreenViewController<TodoEditScreen> {
    // The `todoEditView` has all the logic for displaying the todo and editing.
    let todoEditView: TodoEditView

    required init(screen: TodoEditScreen, viewRegistry: ViewRegistry) {
        self.todoEditView = TodoEditView(frame: .zero)

        super.init(screen: screen, viewRegistry: viewRegistry)
        update(with: screen)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(todoEditView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        todoEditView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }

    override func screenDidChange(from previousScreen: TodoEditScreen) {
        update(with: screen)
    }

    private func update(with screen: TodoEditScreen) {
        // Update the view with the data from the screen.
        todoEditView.title = screen.title
        todoEditView.note = screen.note
        todoEditView.onTitleChanged = screen.onTitleChanged
        todoEditView.onNoteChanged = screen.onNoteChanged
    }

}


extension ViewRegistry {

    public mutating func registerTodoEditScreen() {
        self.register(screenViewControllerType: TodoEditViewController.self)
    }

}
