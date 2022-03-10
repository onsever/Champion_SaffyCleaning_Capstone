//
//  UILabel+Ext.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

extension UILabel {

   func setCharacterSpacing(characterSpacing: CGFloat = 0.0) {

        guard let labelText = text else { return }

        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

       attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSMakeRange(0, attributedString.length))

        attributedText = attributedString
    }

}
