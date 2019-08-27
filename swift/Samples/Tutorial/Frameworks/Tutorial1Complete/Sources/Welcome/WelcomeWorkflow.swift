import Workflow
import WorkflowUI
import ReactiveSwift
import Result


// MARK: Input and Output

struct WelcomeWorkflow: Workflow {

    enum Output {

    }
}


// MARK: State and Initialization

extension WelcomeWorkflow {

    struct State {
        var name: String
    }

    func makeInitialState() -> WelcomeWorkflow.State {
        return State(name: "")
    }

    func workflowDidChange(from previousWorkflow: WelcomeWorkflow, state: inout State) {

    }
}


// MARK: Actions

extension WelcomeWorkflow {

    enum Action: WorkflowAction {

        typealias WorkflowType = WelcomeWorkflow

        case nameChanged(name: String)

        func apply(toState state: inout WelcomeWorkflow.State) -> WelcomeWorkflow.Output? {

            switch self {

            case .nameChanged(name: let name):
                // Update our state with the updated name.
                state.name = name
                // Return nothing for the output, we want to handle this action only at the level of this workflow.
                return nil
            }
        }
    }

}


// MARK: Workers

extension WelcomeWorkflow {

    struct WelcomeWorker: Worker {

        enum Output {

        }

        func run() -> SignalProducer<Output, NoError> {
            fatalError()
        }

        func isEquivalent(to otherWorker: WelcomeWorker) -> Bool {
            return true
        }

    }

}

// MARK: Rendering

extension WelcomeWorkflow {

    typealias Rendering = WelcomeScreen

    func render(state: WelcomeWorkflow.State, context: RenderContext<WelcomeWorkflow>) -> Rendering {
        // Create a "sink" of type `Action`. A sink is what we use to send actions to the workflow.
        let sink = context.makeSink(of: Action.self)

        return WelcomeScreen(
            name: state.name,
            onNameChanged: { name in
                sink.send(.nameChanged(name: name))
        },
            onLoginTapped: {
        })
    }
}
