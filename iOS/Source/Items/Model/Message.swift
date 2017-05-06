import Foundation
import UIKit

struct Message {
    let title: String
    let text: String
    let didSent: Bool
    let image: UIImage?
}

extension Message {

    static func random() -> Message {
        return Message(title: randomString, text: randomString, didSent: randomBool, image: randomImage)
    }
    
    private static var randomBool: Bool { return arc4random_uniform(10) % 2 == 0 ? true : false }
    
    private static var randomString: String {
        
        let text: String = "ipsum dolor sit 😂 amet consectetur adipiscing elit sed 🔥 do eiusmod tempor incididunt ut labore 😍 et dolore magna aliqua Ut 🙄enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut 😘 aliquip ex ea commodo consequat Duis aute irure dolor in reprehenderit in 🤔 voluptate velit esse cillum dolore eu fugiat nulla pariatur Excepteur 😊 sint occaecat cupidatat non proident sunt in culpa qui officia 🤷 deserunt mollit anim id est laborum"
        let words = text.components(separatedBy: " ")
        
        var randomString = "Lorem "
        
        for _ in 0 ..< max(1, Int(arc4random_uniform(15))) {
            let index = Int(arc4random_uniform(UInt32(words.count)))
            randomString += words[index] + " "
        }
        
        return randomString
    }
    
    private static var randomImage: UIImage? {
        let x = Int(arc4random_uniform(40))
        return UIImage(named: "hamster_\(x)")
    }
}
