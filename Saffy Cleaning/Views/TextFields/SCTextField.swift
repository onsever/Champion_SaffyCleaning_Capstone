//
//  SCTextField.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-07.
//

import UIKit

class SCTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(placeholder: String) {
        super.init(frame: .zero)
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistRegular(size: 16)!])
        self.font = .urbanistRegular(size: 16)
        configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.brandGem.cgColor
        self.layer.cornerRadius = 10
        self.textColor = UIColor.brandDark
        self.adjustsFontSizeToFitWidth = true
        self.backgroundColor = .white
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }
    
}
