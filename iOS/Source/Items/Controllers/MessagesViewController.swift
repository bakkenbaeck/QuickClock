import UIKit
import TinyConstraints
import BouncyLayout
import SweetUIKit

struct IndexPathSizes {
    var sizes:[IndexPath: CGSize] = [:]
    
    subscript(indexPath: IndexPath) -> CGSize? {
        get {
            return self.sizes[indexPath]
        } set {
            self.sizes[indexPath] = newValue
        }
    }
}

class MessagesViewController: UIViewController {
    
   var status: Status = .none {
       didSet {
           self.collectionView.reloadData()
       }
   }
    var sizeFor = IndexPathSizes()
    
    lazy var messages = [Message]()
    
    lazy var layout: BouncyLayout = {
        let layout = BouncyLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        (view as UIScrollView).keyboardDismissMode = .interactive
        
        return view
    }()
    
    lazy var dummyCell: MessageCell = {
        return MessageCell()
    }()
    
    lazy var textInputView: UIView = {
        let view = MessageInputView()
        view.delegate = self
        view.backgroundColor = .white
        
        return view
    }()

    
    lazy var animationView: UIView = {
        let view = AnimationContainerView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var textInputBottomConstraint: NSLayoutConstraint!
    var animationContainerHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "@Quick Clock"
        
        view.addSubview(collectionView)
        view.addSubview(textInputView)
        view.addSubview(animationView)
        
        textInputView.left(to: view)
        textInputView.right(to: view)
        textInputBottomConstraint = textInputView.bottom(to: view)
        textInputView.height(40.0)
        
        animationView.left(to: view)
        animationView.right(to: view)
        animationView.height(50.0)
        animationView.bottomToTop(of: textInputView)
        
        collectionView.top(to: view)
        collectionView.left(to: view)
        collectionView.right(to: view)
        collectionView.bottomToTop(of: textInputView)
        
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 15.0, right: 0.0)
    }
    
    func calculateSize(for indexPath: IndexPath) -> CGSize {
        dummyCell.message = messages[indexPath.item]

        let lastMessage = indexPath.row == messages.count - 1
        dummyCell.status = lastMessage ? self.status : .none

        let size = dummyCell.size(for: collectionView.bounds.width)

        return size
    }
}

extension MessagesViewController: MessageInputViewDelegate {
    
    func messageInputViewDidRequireSendMessage(inputView: MessageInputView) {
        if let text = inputView.textField.text as String? {
            self.messages.append(Message(title: "Y.O.U.", text: text, didSent: true, image: nil))
            collectionView.reloadData()
            collectionView.contentOffset = CGPoint(x: 0.0, y: self.collectionView.contentSize.height - 15.0)
        }
    }
}

extension MessagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseIdentifier, for: indexPath)
        
        if var cell = cell as? MessageCellProtocol {
            let message = messages[indexPath.item]
            let lastMessage = indexPath.row == messages.count - 1
            cell.status = lastMessage ? self.status : .none
            
            cell.message = message
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
}

extension MessagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizeFor[indexPath] = calculateSize(for: indexPath)

        return sizeFor[indexPath]!
    }
}

extension MessagesViewController: KeyboardAwareAccessoryViewDelegate {
    func inputView(_ inputView: KeyboardAwareInputAccessoryView, shouldUpdatePosition keyboardOriginYDistance: CGFloat) {
        self.textInputBottomConstraint.constant = keyboardOriginYDistance
        self.view.layoutIfNeeded()
    }
    
    override var inputAccessoryView: UIView? {
        return self.keyboardAwareInputView
    }
}

