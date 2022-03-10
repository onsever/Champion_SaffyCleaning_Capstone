//
//  SCCompletionLabel.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-08.
//

import UIKit

class SCCompletionLabel: UILabel {
    
    private var attributedString: NSMutableAttributedString? = nil
    
    override var text: String? {
        didSet {
            attributedString = NSMutableAttributedString(string: text!)
            attributedString?.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: NSRange())
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            attributedString?.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor ?? .white, range: NSRange())
            attributedString?.addAttribute(NSAttributedString.Key.underlineColor, value: textColor ?? .white, range: NSRange())
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = cornerRadius
        self.font = .urbanistRegular(size: 16)
        configure()
    }
    
    public init(title: String, titleColor: UIColor, fontSize: CGFloat) {
        super.init(frame: .zero)
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: titleColor, NSAttributedString.Key.font: UIFont.urbanistRegular(size: fontSize)!])
        
        self.attributedText = attributedText
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.textAlignment = .center
        self.isUserInteractionEnabled = true
    }
}
