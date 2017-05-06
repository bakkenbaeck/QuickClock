import Foundation
import UIKit

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        if let mask = layer.mask as? CAShapeLayer {
            mask.path = path
        } else {
            let mask = CAShapeLayer()
            mask.path = path
            layer.mask = mask
        }
        
        setNeedsDisplay()
    }
}
