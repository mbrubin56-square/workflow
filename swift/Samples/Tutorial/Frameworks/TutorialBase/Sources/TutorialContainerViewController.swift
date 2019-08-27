import UIKit
import Workflow
import WorkflowUI


public final class TutorialContainerViewController: UIViewController {
    let containerViewController: UIViewController

    public init() {
        // Show one of the sample view controllers, to demonstrate the provided views:
        containerViewController = WelcomeSampleViewController()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        addChild(containerViewController)
        view.addSubview(containerViewController.view)
        containerViewController.didMove(toParent: self)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        containerViewController.view.frame = view.bounds
    }
}
