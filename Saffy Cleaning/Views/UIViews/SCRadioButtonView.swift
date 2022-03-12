//
//  SCRadioButtonView.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit

protocol SCRadioButtonViewDelegate: AnyObject {
    func didTapRadioButton(_ button: UIButton)
}

class SCRadioButtonView: UIView {
    
    public let radioButton = SCRadioButton()
    public let text = SCMainLabel(fontSize: 16, textColor: .brandDark)
    public weak var delegate: SCRadioButtonViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    public init(title: String) {
        super.init(frame: .zero)
        self.text.text = title
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func radioButtonTapped(_ button: UIButton) {
        delegate?.didTapRadioButton(button)
    }
    
    private func configure() {
        self.addSubview(text)
        self.addSubview(radioButton)
        
        radioButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            radioButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            radioButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            radioButton.widthAnchor.constraint(equalToConstant: 15),
            radioButton.heightAnchor.constraint(equalToConstant: 15),
            
            text.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            text.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 10),
            text.widthAnchor.constraint(equalToConstant: 30),
            text.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
