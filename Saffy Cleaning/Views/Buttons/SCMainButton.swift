//
//  SCMainButton.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-07.
//

import UIKit

class SCMainButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String, backgroundColor: UIColor, titleColor: UIColor, cornerRadius: CGFloat, fontSize: CGFloat?) {
        super.init(frame: .zero)
        
        self.setTitle(title.uppercased(), for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = cornerRadius
        
        if let fontSize = fontSize {
            self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        configure()
    }
    
    public init(title: String, backgroundColor: UIColor, titleColor: UIColor, borderColor: UIColor, cornerRadius: CGFloat, fontSize: CGFloat?) {
        super.init(frame: .zero)
        
        self.setTitle(title.uppercased(), for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = cornerRadius
        
        if let fontSize = fontSize {
            self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            self.setTitle(title, for: .normal)
        }

        configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }

}
