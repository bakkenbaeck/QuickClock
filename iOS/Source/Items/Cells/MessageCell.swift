import UIKit

enum Status: Int {
    case none, delivered, read
}

protocol MessageCellProtocol {
    static var reuseIdentifier: String { get }
    var textFont: UIFont { get }
    var statusFont: UIFont { get }

    var message: Message? { get set }
    var status: Status { get set }
    func size(for width: CGFloat) -> CGSize
}

class MessageCell: UICollectionViewCell, MessageCellProtocol {


    static var reuseIdentifier = "MessageCell"
    var textFont: UIFont = UIFont(name: "Helvetica", size: 16)!
    var statusFont: UIFont = UIFont(name: "Helvetica", size: 12)!

    var status: Status = .none {
        didSet {
            switch self.status {
            case .none:
                statusLabelHeightConstraint.constant = 0.0
                self.statusLabel.text = ""
            case .delivered:
                self.statusLabel.text = "Delivered"
                statusLabelHeightConstraint.constant = 20.0
            case .read:
                statusLabelHeightConstraint.constant = 20.0
                self.statusLabel.text = "Read"
            }
        }
    }
    var statusLabelHeightConstraint: NSLayoutConstraint!

    lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = self.statusFont
        statusLabel.textAlignment = .right
        statusLabel.textColor = .darkGray

        return statusLabel
    }()

    lazy var textLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = self.textFont
        
        view.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        
        return view
    }()
    
    private lazy var container: UIView = {
        return UIView()
    }()
    
    private lazy var leftSpacing = UILayoutGuide()
    private lazy var rightSpacing = UILayoutGuide()
    
    private lazy var leftWidthSmall: NSLayoutConstraint = self.leftSpacing.width(0, relation: .equal, isActive: false)
    private lazy var rightWidthSmall: NSLayoutConstraint = self.rightSpacing.width(0, relation: .equal, isActive: false)
    private lazy var leftWidthBig: NSLayoutConstraint = self.leftSpacing.width(80, relation: .equalOrGreater, isActive: false)
    private lazy var rightWidthBig: NSLayoutConstraint = self.rightSpacing.width(80, relation: .equalOrGreater, isActive: false)
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isOpaque = false

        contentView.addSubview(statusLabel)
        contentView.addSubview(container)
        container.addSubview(textLabel)

        contentView.addLayoutGuide(rightSpacing)
        contentView.addLayoutGuide(leftSpacing)
        leftSpacing.top(to: contentView)
        leftSpacing.left(to: contentView, offset: 10)
        leftSpacing.bottom(to: contentView)

        rightSpacing.top(to: contentView)
        rightSpacing.right(to: contentView, offset: -10)
        rightSpacing.bottom(to: contentView)

        leftWidthSmall.isActive = false
        rightWidthBig.isActive = false
        leftWidthBig.isActive = true
        rightWidthSmall.isActive = true

        container.top(to: contentView)
        container.leftToRight(of: leftSpacing)
        container.bottomToTop(of: statusLabel)
        container.rightToLeft(of: rightSpacing)

        textLabel.top(to: container, offset: 5)
        textLabel.left(to: container, offset: 10)
        textLabel.bottom(to: container, offset: -5)
        textLabel.right(to: container, offset: -10)

        statusLabel.leftToRight(of: leftSpacing)
        statusLabelHeightConstraint = statusLabel.height(0)
        statusLabel.rightToLeft(of: rightSpacing)
        statusLabel.bottom(to: contentView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        fixCorners()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func fixCorners() {
        guard let message = message else { return }
        let corners: UIRectCorner = message.didSent ? [.bottomLeft, .topLeft, .topRight] : [.bottomRight, .topLeft, .topRight]
        container.roundCorners(corners, radius: 10)
    }
    
    var message: Message? = nil {
        didSet {
            guard let message = message else { return }
            textLabel.text = message.text
            
            container.backgroundColor = message.didSent ? .quickClockGreen : .quickClockGray
            textLabel.textColor = message.didSent ? .quickClockWhite : .quickClockDarkGray

            if message.didSent {
                leftWidthSmall.isActive = false
                rightWidthBig.isActive = false
                leftWidthBig.isActive = true
                rightWidthSmall.isActive = true
            } else {
                leftWidthBig.isActive = false
                rightWidthSmall.isActive = false
                leftWidthSmall.isActive = true
                rightWidthBig.isActive = true
            }
            
            fixCorners()
            
            if !frame.isEmpty {
                setNeedsLayout()
                layoutIfNeeded()
            }
        }
    }
    
    func size(for width: CGFloat) -> CGSize {
        guard let message = message else { return .zero }
        
        let maxWidth: CGFloat = width - 80 - 20

        var statusLabelHeight: CGFloat  = 0.0
        switch self.status {
        case .none:
            statusLabelHeightConstraint.constant = 0.0
            self.statusLabel.text = ""
        case .delivered:
            self.statusLabel.text = "Delivered"
            statusLabelHeight = 20.0
            statusLabelHeightConstraint.constant = 20.0
        case .read:
            statusLabelHeight = 20.0
            statusLabelHeightConstraint.constant = 20.0
            self.statusLabel.text = "Read"
        }

        let textHeight = message.text.height(withConstrainedWidth: maxWidth - 20, font: textFont)

        let cellHeight = ceil(textHeight + 10 + statusLabelHeight)
        print(cellHeight)
        return CGSize(width: ceil(width), height: cellHeight)
    }
}
