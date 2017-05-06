import UIKit

protocol MessageCellProtocol {
    static var reuseIdentifier: String { get }
    var titleFont: UIFont { get }
    var textFont: UIFont { get }
    
    var message: Message? { get set }
    func size(for width: CGFloat) -> CGSize
}

class MessageCell: UICollectionViewCell, MessageCellProtocol {
    
    static var reuseIdentifier = "MessageCell"
    var titleFont: UIFont = UIFont(name: "Helvetica", size: 16)!
    var textFont: UIFont = UIFont(name: "Helvetica", size: 12)!
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = self.titleFont
        
        view.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = self.textFont
        
        view.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        view.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        
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
        
        let margin: CGFloat = 10
        
        contentView.addLayoutGuide(leftSpacing)
        leftSpacing.top(to: contentView)
        leftSpacing.left(to: contentView, offset: 10)
        leftSpacing.bottom(to: contentView)
        
        contentView.addLayoutGuide(rightSpacing)
        rightSpacing.top(to: contentView)
        rightSpacing.right(to: contentView, offset: -10)
        rightSpacing.bottom(to: contentView)
        
        leftWidthSmall.isActive = false
        rightWidthBig.isActive = false
        leftWidthBig.isActive = true
        rightWidthSmall.isActive = true
        
        contentView.addSubview(container)
        container.top(to: contentView)
        container.leftToRight(of: leftSpacing)
        container.bottom(to: contentView)
        container.rightToLeft(of: rightSpacing)
        
        container.addSubview(imageView)
        imageView.top(to: container)
        imageView.left(to: container)
        imageView.right(to: container)
        
        container.addSubview(titleLabel)
        titleLabel.topToBottom(of: imageView, offset: margin)
        titleLabel.left(to: container, offset: margin)
        titleLabel.right(to: container, offset: -margin)
        
        container.addSubview(textLabel)
        textLabel.topToBottom(of: titleLabel, offset: margin)
        textLabel.left(to: container, offset: margin)
        textLabel.bottom(to: container, offset: -margin)
        textLabel.right(to: container, offset: -margin)
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
            imageView.image = message.image
            titleLabel.text = message.title
            textLabel.text = message.text
            
            container.backgroundColor = message.didSent ? .tokenGreen : .tokenGray
            titleLabel.textColor = message.didSent ? .tokenWhite : .tokenDarkGray
            textLabel.textColor = message.didSent ? .tokenWhite : .tokenDarkGray
            
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
        
        var imageHeight: CGFloat = 0
        if let image = message.image {
            
            let scaleFactor = maxWidth / image.size.width
            let targetHeight = image.size.height * scaleFactor
            
            imageHeight = min(200, targetHeight)
        }
        
        let titleHeight = message.title.height(withConstrainedWidth: maxWidth - 20, font: titleFont)
        let textHeight = message.text.height(withConstrainedWidth: maxWidth - 20, font: textFont)
        
        return CGSize(width: ceil(width), height: ceil(imageHeight + titleHeight + textHeight + 30))
    }
}
