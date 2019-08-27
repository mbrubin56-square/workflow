import UIKit


public final class TodoListView: UIView, UITableViewDelegate, UITableViewDataSource {
    public var todoList: [String] {
        didSet {
            tableView.reloadData()
        }
    }

    public var onTodoSelected: (Int) -> Void

    let titleLabel: UILabel
    let tableView: UITableView

    public override init(frame: CGRect) {
        todoList = []
        onTodoSelected = { _ in }
        titleLabel = UILabel(frame: .zero)
        tableView = UITableView()

        super.init(frame: frame)

        backgroundColor = .white

        titleLabel.text = "What do you have to do?"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        tableView.delegate = self
        tableView.dataSource = self

        addSubview(titleLabel)
        addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIView

    public override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: bounds.maxX,
            height: 44.0)

        let yOffset = titleLabel.frame.maxY + 8.0

        tableView.frame = CGRect(
            x: bounds.minX,
            y: yOffset,
            width: bounds.maxX,
            height: bounds.maxY - yOffset)
    }

    // MARK: UITableViewDelegate, UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.textLabel?.text = todoList[indexPath.row]

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        onTodoSelected(indexPath.row)
    }

}
