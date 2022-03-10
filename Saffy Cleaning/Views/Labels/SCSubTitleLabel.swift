//
//  SCSubTitleLabel.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-07.
//

import UIKit

class SCSubTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(text: String, isRequired: Bool, textColor: UIColor) {
        super.init(frame: .zero)
        
        if isRequired {
            let attributedText = NSMutableAttributedString(string: "* ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandError])
            attributedText.append(NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark]))
            
            self.attributedText = attributedText
        }
        else {
            self.text = text
            self.textColor = textColor
        }
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 3
        self.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
}
