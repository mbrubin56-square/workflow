import Workflow
import WorkflowUI
import BackStackContainer
import ReactiveSwift
import Result


// MARK: Input and Output

struct TodoListWorkflow: Workflow {

    // The name is an input.
    var name: String
    // Use the list of todo items passed from our parent.
    var todos: [TodoModel]

    enum Output {
        case back
        case selectTodo(index: Int)
        case newTodo
    }
}


// MARK: State and Initialization

extension TodoListWorkflow {

    struct State {
    }

    func makeInitialState() -> TodoListWorkflow.State {
        return State()
    }

    func workflowDidChange(from previousWorkflow: TodoListWorkflow, state: inout State) {

    }
}


// MARK: Actions

extension TodoListWorkflow {

    enum Action: WorkflowAction {

        typealias WorkflowType = TodoListWorkflow

        case onBack
        case selectTodo(index: Int)
        case new

        func apply(toState state: inout TodoListWorkflow.State) -> TodoListWorkflow.Output? {

            switch self {

            case .onBack:
                // When a `.onBack` action is received, emit a `.back` output
                return .back

            case .selectTodo(index: let index):
                // Tell our parent that a todo item was selected.
                return .selectTodo(index: index)

            case .new:
                // Tell our parent a new todo item should be created.
                return .newTodo
            }

        }
    }
}


// MARK: Workers

extension TodoListWorkflow {

    struct TodoListWorker: Worker {

        enum Output {

        }

        func run() -> SignalProducer<Output, NoError> {
            fatalError()
        }

        func isEquivalent(to otherWorker: TodoListWorker) -> Bool {
            return true
        }

    }

}

// MARK: Rendering

extension TodoListWorkflow {

    typealias Rendering = BackStackScreen.Item

    func render(state: TodoListWorkflow.State, context: RenderContext<TodoListWorkflow>) -> Rendering {

        // Define a sink to be able to send the .onBack action.
        let sink = context.makeSink(of: Action.self)

        let titles = todos.map { (todoModel) -> String in
            return todoModel.title
        }
        let todoListScreen = TodoListScreen(
            todoTitles: titles,
            onTodoSelected: { index in
                // Send the `selectTodo` action when a todo is selected in the UI.
                sink.send(.selectTodo(index: index))
        })

        let todoListItem = BackStackScreen.Item(
            key: "list",
            screen: todoListScreen,
            barContent: BackStackScreen.BarContent(
                title: "Welcome \(name)",
                leftItem: .back(handler: {
                    // When the left button is tapped, send the .onBack action.
                    sink.send(.onBack)
                }),
                rightItem: .button(
                    content: .text("New Todo"),
                    handler: {
                        sink.send(.new)
                })))

        return todoListItem
    }
}
