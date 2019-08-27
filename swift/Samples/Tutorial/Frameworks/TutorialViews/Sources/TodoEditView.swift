import UIKit


public final class TodoEditView: UIView, UITextViewDelegate {

    public var title: String {
        didSet {
            titleField.text = title
        }
    }

    public var note: String {
        didSet {
            noteField.text = note
        }
    }

    public var onTitleChanged: (String) -> Void
    public var onNoteChanged: (String) -> Void

    let titleField: UITextField
    let noteField: UITextView

    public override init(frame: CGRect) {
        title = ""
        note = ""
        onTitleChanged = { _ in }
        onNoteChanged = { _ in }

        titleField = UITextField(frame: .zero)
        noteField = UITextView(frame: .zero)

        super.init(frame: frame)

        backgroundColor = .white

        titleField.textAlignment = .center
        titleField.addTarget(self, action: #selector(titleDidChange(sender:)), for: .editingChanged)
        titleField.layer.borderColor = UIColor.black.cgColor
        titleField.layer.borderWidth = 1.0

        noteField.delegate = self
        noteField.layer.borderColor = UIColor.gray.cgColor
        noteField.layer.borderWidth = 1.0

        addSubview(titleField)
        addSubview(noteField)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let titleHeight: CGFloat = 44.0
        let spacing: CGFloat = 8.0
        let widthInset: CGFloat = 8.0

        var yOffset = bounds.minY

        titleField.frame = CGRect(
            x: bounds.minX,
            y: yOffset,
            width: bounds.maxX,
            height: titleHeight)
            .insetBy(dx: widthInset, dy: 0.0)

        yOffset += titleHeight + spacing

        noteField.frame = CGRect(
            x: bounds.minX,
            y: yOffset,
            width: bounds.maxX,
            height: bounds.maxY - yOffset)
            .insetBy(dx: widthInset, dy: 0.0)
    }

    @objc private func titleDidChange(sender: UITextField) {
        guard let titleText = sender.text else {
            return
        }

        onTitleChanged(titleText)
    }

    // MARK: UITextFieldDelegate

    @objc public func textViewDidChange(_ textView: UITextView) {
        guard textView === noteField else {
            return
        }

        guard let noteText = textView.text else {
            return
        }

        onNoteChanged(noteText)
    }
}
