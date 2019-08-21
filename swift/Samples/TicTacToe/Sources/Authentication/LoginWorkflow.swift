import Workflow
import WorkflowUI
import ReactiveSwift
import Result


// MARK: Input and Output

struct LoginWorkflow: Workflow {
    var error: AuthenticationService.AuthenticationError?

    enum Output {
        case login(email: String, password: String)
    }
}


// MARK: State and Initialization

extension LoginWorkflow {

    struct State {
        var email: String
        var password: String
    }

    func makeInitialState() -> LoginWorkflow.State {
        return State(email: "", password: "")
    }

    func workflowDidChange(from previousWorkflow: LoginWorkflow, state: inout State) {

    }
}


// MARK: Actions

extension LoginWorkflow {

    enum Action: WorkflowAction {

        typealias WorkflowType = LoginWorkflow

        case emailUpdated(String)
        case passwordUpdated(String)
        case login

        func apply(toState state: inout LoginWorkflow.State) -> LoginWorkflow.Output? {

            switch self {
            case .emailUpdated(let email):
                state.email = email

            case .passwordUpdated(let password):
                state.password = password

            case .login:
                return .login(email: state.email, password: state.password)
            }

            return nil
        }
    }
}


// MARK: Rendering

extension LoginWorkflow {

    typealias Rendering = LoginScreen

    func render(state: LoginWorkflow.State, context: RenderContext<LoginWorkflow>) -> Rendering {
        let sink = context.makeSink(of: Action.self)

        let title: String
        if let authenticationError = error {
            title = authenticationError.localizedDescription
        } else {
            title = "Welcome! Please log in to play TicTacToe!"
        }

        return LoginScreen(
            title: title,
            email: state.email,
            onEmailChanged: { email in
                sink.send(.emailUpdated(email))
            },
            password: state.password,
            onPasswordChanged: { password in
                sink.send(.passwordUpdated(password))
            },
            onLoginTapped: {
                sink.send(.login)
            })

    }
}
