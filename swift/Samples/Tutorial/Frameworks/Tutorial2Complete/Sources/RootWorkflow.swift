import Workflow
import WorkflowUI
import BackStackContainer
import ReactiveSwift
import Result


// MARK: Input and Output

struct RootWorkflow: Workflow {

    enum Output {

    }
}


// MARK: State and Initialization

extension RootWorkflow {

    // The state is an enum, and can either be on the welcome screen or the todo list.
    // When on the todo list, it also includes the name provided on the welcome screen
    enum State {
        // The welcome screen via the welcome workflow will be shown
        case welcome
        // The todo list screen via the todo list workflow will be shown. The name will be provided to the todo list.
        case todo(name: String)
    }

    func makeInitialState() -> RootWorkflow.State {
        return .welcome
    }

    func workflowDidChange(from previousWorkflow: RootWorkflow, state: inout State) {

    }
}


// MARK: Actions

extension RootWorkflow {

    enum Action: WorkflowAction {

        typealias WorkflowType = RootWorkflow

        case login(name: String)
        case logout

        func apply(toState state: inout RootWorkflow.State) -> RootWorkflow.Output? {

            switch self {
            case .login(name: let name):
                // When the `login` action is received, change the state to `todo`.
                state = .todo(name: name)
            case .logout:
                // Return to the welcome state on logout.
                state = .welcome
            }
            return nil

        }
    }
}


// MARK: Workers

extension RootWorkflow {

    struct RootWorker: Worker {

        enum Output {

        }

        func run() -> SignalProducer<Output, NoError> {
            fatalError()
        }

        func isEquivalent(to otherWorker: RootWorker) -> Bool {
            return true
        }

    }

}

// MARK: Rendering

// MARK: Rendering

extension RootWorkflow {

    typealias Rendering = BackStackScreen

    func render(state: RootWorkflow.State, context: RenderContext<RootWorkflow>) -> Rendering {
        // Create a sink to handle the back action from the TodoListWorkflow to logout.
        let sink = context.makeSink(of: Action.self)

        // Our list of back stack items. Will always include the "WelcomeScreen".
        var backStackItems: [BackStackScreen.Item] = []

        let welcomeScreen = WelcomeWorkflow()
            .mapOutput({ output -> Action in
                switch output {
                // When `WelcomeWorkflow` emits `didLogin`, turn it into our `login` action.
                case .didLogin(name: let name):
                    return .login(name: name)
                }
            })
            .rendered(with: context)

        let welcomeBackStackItem = BackStackScreen.Item(
            key: "welcome",
            screen: welcomeScreen,
            // Hide the navigation bar.
            barVisibility: .hidden)

        // Always add the welcome back stack item.
        backStackItems.append(welcomeBackStackItem)

        switch state {
        // When the state is `.welcome`, defer to the WelcomeWorkflow.
        case .welcome:
            // We always add the welcome screen to the backstack, so this is a no op.
            break

        // When the state is `.todo`, defer to the TodoListWorkflow.
        case .todo(name: let name):

            let todoListScreen = TodoListWorkflow()
                .rendered(with: context)

            let todoListBackStackItem = BackStackScreen.Item(
                key: "todoList",
                screen: todoListScreen,
                // Specify the title, back button, and right button.
                barContent: BackStackScreen.BarContent(
                    title: "Welcome \(name)",
                    // When `back` is pressed, emit the .logout action to return to the welcome screen.
                    leftItem: .button(.back(handler: {
                        sink.send(.logout)
                    })),
                    rightItem: .none))

            // Add the TodoListScreen to our BackStackItems.
            backStackItems.append(todoListBackStackItem)
        }

        // Finally, return the BackStackScreen with a list of BackStackScreen.Items
        return BackStackScreen(items: backStackItems)
    }
}
