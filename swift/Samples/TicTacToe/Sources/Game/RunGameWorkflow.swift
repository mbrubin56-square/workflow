import Workflow
import WorkflowUI
import BackStackContainer


// MARK: Input and Output

struct RunGameWorkflow: Workflow {
    typealias Output = Never
}


// MARK: State and Initialization

extension RunGameWorkflow {

    struct State {
        var playerX: String
        var playerO: String
        var step: Step

        enum Step {
            case newGame
            case playing
        }
    }

    func makeInitialState() -> RunGameWorkflow.State {
        return State(playerX: "X", playerO: "O", step: .newGame)
    }

    func workflowDidChange(from previousWorkflow: RunGameWorkflow, state: inout State) {

    }
}


// MARK: Actions

extension RunGameWorkflow {

    enum Action: WorkflowAction {

        typealias WorkflowType = RunGameWorkflow

        case updatePlayerX(String)
        case updatePlayerO(String)
        case startGame
        case back

        func apply(toState state: inout RunGameWorkflow.State) -> RunGameWorkflow.Output? {

            switch self {
            case .updatePlayerX(let name):
                state.playerX = name

            case .updatePlayerO(let name):
                state.playerO = name

            case .startGame:
                state.step = .playing

            case .back:
                state.step = .newGame
            }

            return nil
        }
    }
}


// MARK: Rendering

extension RunGameWorkflow {

    typealias Rendering = BackStackScreen

    func render(state: RunGameWorkflow.State, context: RenderContext<RunGameWorkflow>) -> Rendering {
        let sink = context.makeSink(of: Action.self)

        var backStackItems: [BackStackScreen.Item] = [BackStackScreen.Item(
            screen: newGameScreen(
                sink: sink,
                playerX: state.playerX,
                playerO: state.playerO))]
        switch state.step {
        case .newGame:
            break

        case .playing:
            let takeTurnsScreen = TakeTurnsWorkflow(
                playerX: state.playerX,
                playerO: state.playerO)
                .rendered(with: context)
            backStackItems.append(BackStackScreen.Item(
                screen: takeTurnsScreen,
                barVisibility: .visible(BackStackScreen.BarContent(
                    leftItem: BackStackScreen.BarContent.BarButtonItem.some(BackStackScreen.BarContent.BarButtonViewModel(
                        labelType: .text("Quit"),
                        handler: {
                            sink.send(.back)
                        }))))))
        }

        return BackStackScreen(items: backStackItems)
    }

    private func newGameScreen(sink: Sink<Action>, playerX: String, playerO: String) -> NewGameScreen {
        return NewGameScreen(
            playerX: playerX,
            playerO: playerO,
            eventHandler: { event in
                switch event {
                case .startGame:
                    sink.send(.startGame)

                case .playerXChanged(let name):
                    sink.send(.updatePlayerX(name))

                case .playerOChanged(let name):
                    sink.send(.updatePlayerO(name))
                }
            })
    }
}
