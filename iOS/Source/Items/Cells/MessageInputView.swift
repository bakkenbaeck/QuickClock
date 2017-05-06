import Foundation
import SweetUIKit

protocol MessageInputViewDelegate: class {
    func messageInputViewDidRequireSendMessage(inputView: MessageInputView)
}

final class MessageInputView: UIView {

    var delegate: MessageInputViewDelegate?
    
    private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private(set) lazy var sendButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func sendButtonPressed(_ sender: UIButton) {
        self.delegate?.messageInputViewDidRequireSendMessage(inputView: self)
        self.textField.text = nil
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        addSubviewsAndConstraints()
    }
    
    private func addSubviewsAndConstraints() {
        self.addSubview(textField)
        self.addSubview(sendButton)
        
        sendButton.height(40.0)
        sendButton.width(80.0)
        sendButton.right(to: self)
        sendButton.bottom(to: self)
        sendButton.top(to: self)
        
        textField.left(to: self)
        textField.rightToLeft(of: sendButton)
        textField.bottom(to: self)
        textField.top(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
