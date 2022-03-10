//
//  SCInfoView.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-07.
//

import UIKit

class SCInfoView: UIView {
    
    private var placeholderText: String = ""
    private var labelText: String = ""
    
    private lazy var textField = SCTextField(placeholder: placeholderText)
    private lazy var mainLabel = SCSubTitleLabel(text: labelText, isRequired: false, textColor: .brandDark)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public init(placeholder: String, text: String) {
        super.init(frame: .zero)
        
        placeholderText = placeholder
        labelText = text
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(mainLabel)
        self.addSubview(textField)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: self.topAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 20),
            
            textField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    public func getTextField() -> UITextField {
        return self.textField
    }
    
}
