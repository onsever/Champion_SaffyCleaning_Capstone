//
//  SCTipsView.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-15.
//

import UIKit

class SCTipsView: UIView {

    private let titleLabel = SCTitleLabel(fontSize: 20, textColor: .brandGem)
    public let amountTextField = SCTextField(placeholder: "Amount")
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public init(title: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        
        configure()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 15
        self.backgroundColor = .lightBrandLake3
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }
    
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        self.addSubview(amountTextField)
        titleLabel.font = .urbanistBold(size: 20)
        amountTextField.keyboardType = .numberPad
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            amountTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            amountTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            amountTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

}
