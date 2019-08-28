import Workflow
import WorkflowUI
import BackStackContainer
import ReactiveSwift
import Result


// MARK: Input and Output

struct TodoEditWorkflow: Workflow {

    // The "Todo" passed from our parent.
    var initialTodo: TodoModel

    enum Output {
        case discard
        case save(TodoModel)
    }
}


// MARK: State and Initialization

extension TodoEditWorkflow {

    struct State {
        // The workflow's copy of the Todo item. Changes are local to this workflow.
        var todo: TodoModel
    }

    func makeInitialState() -> TodoEditWorkflow.State {
        return State(todo: initialTodo)
    }

    func workflowDidChange(from previousWorkflow: TodoEditWorkflow, state: inout State) {

        // The `Todo` from our parent changed. Update our internal copy so we are starting from the same item.
        // The "correct" behavior depends on the business logic - would we only want to update if the
        // users hasn't changed the todo from the initial one? Or is it ok to delete whatever edits
        // were in progress if the state from the parent changes?
        if previousWorkflow.initialTodo != self.initialTodo {
            state.todo = self.initialTodo
        }
    }
}


// MARK: Actions

extension TodoEditWorkflow {

    enum Action: WorkflowAction {

        typealias WorkflowType = TodoEditWorkflow

        case titleChanged(String)
        case noteChanged(String)
        case discardChanges
        case saveChanges

        func apply(toState state: inout TodoEditWorkflow.State) -> TodoEditWorkflow.Output? {

            switch self {

            case .titleChanged(let title):
                state.todo.title = title

            case .noteChanged(let note):
                state.todo.note = note

            case .discardChanges:
                // Return the .discard output when the discard action is received.
                return .discard

            case .saveChanges:
                // Return the .save output with the current todo state when the save action is received.
                return .save(state.todo)
            }

            return nil
        }
    }
}


// MARK: Workers

extension TodoEditWorkflow {

    struct TodoEditWorker: Worker {

        enum Output {

        }

        func run() -> SignalProducer<Output, NoError> {
            fatalError()
        }

        func isEquivalent(to otherWorker: TodoEditWorker) -> Bool {
            return true
        }

    }

}

// MARK: Rendering

extension TodoEditWorkflow {

    typealias Rendering = BackStackScreen.Item

    func render(state: TodoEditWorkflow.State, context: RenderContext<TodoEditWorkflow>) -> Rendering {
        // The sink is used to send actions back to this workflow.
        let sink = context.makeSink(of: Action.self)

        let todoEditScreen = TodoEditScreen(
            title: state.todo.title,
            note: state.todo.note,
            onTitleChanged: { title in
                sink.send(.titleChanged(title))
            },
            onNoteChanged: { note in
                sink.send(.noteChanged(note))
            })

        let backStackItem = BackStackScreen.Item(
            key: "edit",
            screen: todoEditScreen,
            barContent: BackStackScreen.BarContent(
                title: "Edit",
                leftItem: .button(.back(handler: {
                    sink.send(.discardChanges)
                })),
                rightItem: .button(BackStackScreen.BarContent.Button(
                    content: .text("Save"),
                    handler: {
                        sink.send(.saveChanges)
                }))))
        return backStackItem
    }
}
