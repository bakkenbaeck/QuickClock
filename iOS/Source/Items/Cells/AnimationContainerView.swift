import Foundation
import UIKit

final class AnimationContainerView: UIView {
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView.init(frame: CGRect.zero)
        view.contentMode = .scaleAspectFit
        let typingGif = UIImage.gifImageWithName("typing")
        view.image = typingGif
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewsAndConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviewsAndConstraints() {
        addSubview(imageView)
        
        imageView.top(to: self)
        imageView.left(to: self, offset: 20.0)
        imageView.width(50)
        imageView.bottom(to: self)
        
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }
}

