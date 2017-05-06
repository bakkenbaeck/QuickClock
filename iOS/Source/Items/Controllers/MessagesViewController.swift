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
    
    lazy var scenario: Scenario = {
        let scenario = Scenario()
        scenario.delegate = self
        
        return scenario
    }()
    
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

    static let animationViewHeightConstraint: CGFloat = 30.0
    
    lazy var animationView: AnimationContainerView = {
        let view = AnimationContainerView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var textInputBottomConstraint: NSLayoutConstraint!
    var animationContainerHeightConsraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Quick Clock"
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(textInputView)
        view.addSubview(animationView)
        
        textInputView.left(to: view, offset: 3.0)
        textInputView.right(to: view, offset: 3.0)
        textInputBottomConstraint = textInputView.bottom(to: view, offset: -5.0)
        textInputView.height(40.0)
        
        animationView.left(to: view)
        animationView.right(to: view)
        animationContainerHeightConsraint = animationView.height(0.0)
        animationView.bottomToTop(of: textInputView)
        
        collectionView.top(to: view)
        collectionView.left(to: view)
        collectionView.right(to: view)
        collectionView.bottomToTop(of: textInputView)
        
        collectionView.contentInset = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 15.0, right: 0.0)
    }
    
    func calculateSize(for indexPath: IndexPath) -> CGSize {
        dummyCell.message = messages[indexPath.item]
        
        return dummyCell.size(for: collectionView.bounds.width)
    }
    
    func stopTypingAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animationView.imageView.alpha = 0.0
        }) { finished in
            self.animationContainerHeightConsraint?.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func startTypingAnimation() {
        self.animationView.imageView.alpha = 0.0
        
        self.animationContainerHeightConsraint?.constant = MessagesViewController.animationViewHeightConstraint
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animationView.imageView.alpha = 1.0
        }, completion: nil)
    }
}

extension MessagesViewController: ScenarioDelegate {
    func didResponse(on scenario: Scenario) {
        self.messages.append(Message(title: "Clocky", text: scenario.timeString, didSent: false, image: nil))
        collectionView.reloadData()
        collectionView.contentOffset = CGPoint(x: 0.0, y: self.collectionView.contentSize.height - 15.0)
    }
    
    func didPause(on scenario: Scenario) {
        self.stopTypingAnimation()
    }
    
    func didType(on scenario: Scenario) {
        self.startTypingAnimation()
    }
    
    func didReadMessage(on scenario: Scenario) {
    
    }
    
    func didDeliverMessage(on scenario: Scenario) {
    
    }
}

extension MessagesViewController: MessageInputViewDelegate {
    
    func messageInputViewDidRequireSendMessage(inputView: MessageInputView) {
        if let text = inputView.textField.text as String? {
            self.messages.append(Message(title: "Y.O.U.", text: text, didSent: true, image: nil))
            collectionView.reloadData()
            
            self.scenario.createScenario()
            self.scenario.executeScenario()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.startTypingAnimation()
            })
            
            collectionView.contentOffset = CGPoint(x: 0.0, y: self.collectionView.contentSize.height - 15.0)
        }
    }
}

extension MessagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseIdentifier, for: indexPath)
        
        if var cell = cell as? MessageCellProtocol {
            let message = messages[indexPath.item]
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
        
        if sizeFor[indexPath] == nil {
            sizeFor[indexPath] = calculateSize(for: indexPath)
        }
        
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

