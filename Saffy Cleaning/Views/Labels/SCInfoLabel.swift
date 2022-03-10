//
//  SCInfoLabel.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-07.
//

import UIKit

class SCInfoLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(alignment: NSTextAlignment, fontSize: CGFloat, text: String) {
        super.init(frame: .zero)
        
        /*
        let attributedText = NSMutableAttributedString(string: "Accept the ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold)])
        
        let privacyPolicyText = NSAttributedString(string: "Privacy Policy", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandGem, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .medium), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: UIColor.brandGem])
        
        let dividerText = NSAttributedString(string: " and ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold)])
        
        let termsConditionsText = NSAttributedString(string: "Terms & Conditions", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandGem, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .medium), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: UIColor.brandGem])
        
        attributedText.append(privacyPolicyText)
        attributedText.append(dividerText)
        attributedText.append(termsConditionsText)
        
        self.attributedText = attributedText
        self.textAlignment = alignment
         */
        
        
        let attributedText = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Privacy Policy")
        let range2 = (text as NSString).range(of: "Terms & Conditions.")
        
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.brandGem, range: range1)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize, weight: .medium), range: range1)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range1)
        attributedText.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.brandGem, range: range1)
        
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.brandGem, range: range2)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize, weight: .medium), range: range2)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range2)
        attributedText.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.brandGem, range: range2)
        
        self.attributedText = attributedText
        
        configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
}
