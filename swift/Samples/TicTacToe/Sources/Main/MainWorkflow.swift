import Workflow
import WorkflowUI
import BackStackContainer


// MARK: Input and Output

struct MainWorkflow: Workflow {
    typealias Output = Never
}


// MARK: State and Initialization

extension MainWorkflow {

    enum State {
        case authenticating
        case runningGame(sessionToken: String)
    }

    func makeInitialState() -> MainWorkflow.State {
        return .authenticating
    }

    func workflowDidChange(from previousWorkflow: MainWorkflow, state: inout State) {

    }
}


// MARK: Actions

extension MainWorkflow {

    enum Action: WorkflowAction {

        typealias WorkflowType = MainWorkflow

        case authenticated(sessionToken: String)
        case logout

        func apply(toState state: inout MainWorkflow.State) -> MainWorkflow.Output? {

            switch self {
            case .authenticated(sessionToken: let sessionToken):
                state = .runningGame(sessionToken: sessionToken)

            case .logout:
                state = .authenticating
            }

            return nil

        }
    }
}


// MARK: Rendering

extension MainWorkflow {

    typealias Rendering = BackStackScreen

    func render(state: MainWorkflow.State, context: RenderContext<MainWorkflow>) -> Rendering {

        switch state {
        case .authenticating:
            let authenticationBackStackItems = AuthenticationWorkflow(
                authenticationService: AuthenticationService())
                .mapOutput({ output -> Action in
                    switch output {
                    case .authorized(session: let sessionToken):
                        return .authenticated(sessionToken: sessionToken)
                    }
                })
                .rendered(with: context)

            return BackStackScreen(items: authenticationBackStackItems)

        case .runningGame:
            return RunGameWorkflow().rendered(with: context)
        }

    }
}
