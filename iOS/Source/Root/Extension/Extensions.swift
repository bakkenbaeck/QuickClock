import Foundation
import UIKit

extension UIColor {
    
    open class var tokenWhite: UIColor {
        return UIColor.white
    }
    
    open class var tokenGray: UIColor {
        return UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
    }
    
    open class var tokenDarkGray: UIColor {
        return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
    
    open class var tokenGreen: UIColor {
        return UIColor(red: 87/255, green: 190/255, blue: 76/255, alpha: 1)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

extension NSAttributedString {
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

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
