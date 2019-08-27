import Workflow
import WorkflowUI
import ReactiveSwift
import Result


// MARK: Input and Output

struct TodoListWorkflow: Workflow {
    typealias Output = Never
}


// MARK: State and Initialization

extension TodoListWorkflow {

    struct State {
        var todos: [TodoModel]
    }

    func makeInitialState() -> TodoListWorkflow.State {
        return State(todos: [TodoModel(title: "Take the cat for a walk", note: "Cats really need their outside sunshine time. Don't forget to walk Charlie. Hamilton is less excited about the prospect.")])
    }

    func workflowDidChange(from previousWorkflow: TodoListWorkflow, state: inout State) {

    }
}


// MARK: Actions

extension TodoListWorkflow {

    enum Action: WorkflowAction {

        typealias WorkflowType = TodoListWorkflow

        func apply(toState state: inout TodoListWorkflow.State) -> TodoListWorkflow.Output? {

            switch self {
                // Update state and produce an optional output based on which action was received.
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

    typealias Rendering = TodoListScreen

    func render(state: TodoListWorkflow.State, context: RenderContext<TodoListWorkflow>) -> Rendering {
        let titles = state.todos.map { (todoModel) -> String in
            return todoModel.title
        }
        return TodoListScreen(
            todoTitles: titles,
            onTodoSelected: { _ in })
    }
}
