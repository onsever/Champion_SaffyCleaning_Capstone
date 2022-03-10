//
//  Extensions.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension UIView {
    
    func animateWithSpring() {
        self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
}

extension UIColor {
    
    static let brandGem = UIColor(red: 0.02, green: 0.68, blue: 0.75, alpha: 1.00)
    
    static let brandYellow = UIColor(red: 0.95, green: 0.80, blue: 0.03, alpha: 1.00)
    
    static let brandLake = UIColor(red: 0.55, green: 0.80, blue: 0.95, alpha: 1.00)
    
    static let brandDark = UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 1.00)
    
    static let brandError = UIColor(red: 0.75, green: 0.06, blue: 0.02, alpha: 1.00)
    
    static let lightBrandLake = UIColor(red: 0.81, green: 0.87, blue: 0.91, alpha: 1.00)
    
    static let lightBrandLake2 = UIColor(red: 0.68, green: 0.84, blue: 0.86, alpha: 1.00)
    
    static let lightBrandLake3 = UIColor(red: 0.71, green: 0.86, blue: 0.88, alpha: 1.00)
    
}

extension UILabel {

   func setCharacterSpacing(characterSpacing: CGFloat = 0.0) {

        guard let labelText = text else { return }

        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Character spacing attribute
       attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSMakeRange(0, attributedString.length))

        attributedText = attributedString
    }

}
