//
//  SCPolicyView.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-08.
//

import UIKit

protocol SCPolicyViewDelegate: AnyObject {
    func didSelectCheckbox(_ button: UIButton)
    func didTapPolicy()
    func didTapTermsAndConditions()
}

class SCPolicyView: UIView {
    
    private let fontSize: CGFloat = 11
    
    public let checkBox = SCCheckBox(frame: .zero)
    public weak var delegate: SCPolicyViewDelegate?
    private let infoLabel = SCInfoLabel(frame: .zero)
    private let andLabel = SCInfoLabel(frame: .zero)
    private lazy var policyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.brandDark, for: .normal)
        button.titleLabel?.font = UIFont.urbanistRegular(size: fontSize)!
        button.setAttributedTitle(generateAttributedString(with: "Privacy Policy"), for: .normal)
        
        return button
    }()
    
    private lazy var termsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.brandDark, for: .normal)
        button.titleLabel?.font = UIFont.urbanistRegular(size: fontSize)!
        button.setAttributedTitle(generateAttributedString(with: "Terms & Conditions."), for: .normal)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(checkBox)
        self.addSubview(infoLabel)
        self.addSubview(policyButton)
        self.addSubview(andLabel)
        self.addSubview(termsButton)
        
        policyButton.addTarget(self, action: #selector(didTapPolicyText(_:)), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsConditionsText(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            checkBox.widthAnchor.constraint(equalToConstant: 18),
            checkBox.heightAnchor.constraint(equalToConstant: 18),
            
            infoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 10),
            infoLabel.heightAnchor.constraint(equalToConstant: 20),
            
            policyButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            policyButton.leadingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            policyButton.heightAnchor.constraint(equalToConstant: 20),
            
            andLabel.leadingAnchor.constraint(equalTo: policyButton.trailingAnchor),
            andLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            andLabel.heightAnchor.constraint(equalToConstant: 20),
            
            termsButton.leadingAnchor.constraint(equalTo: andLabel.trailingAnchor),
            termsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            termsButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        infoLabel.text = "Accept the "
        infoLabel.font = UIFont.urbanistRegular(size: fontSize)!
        andLabel.text = " and "
        andLabel.font = UIFont.urbanistRegular(size: fontSize)!
        
        self.checkBox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        
    }
    
    private func generateAttributedString(with string: String) -> NSAttributedString {
        
        let attributedString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandGem, NSAttributedString.Key.font: UIFont.urbanistRegular(size: fontSize)!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: UIColor.brandGem])
        
        return attributedString
    }
    
    @objc private func checkBoxTapped(_ button: UIButton) {
        delegate?.didSelectCheckbox(button)
    }
    
    
    @objc private func didTapPolicyText(_ button: UIButton) {
        delegate?.didTapPolicy()
    }
    
    @objc private func didTapTermsConditionsText(_ button: UIButton) {
        delegate?.didTapTermsAndConditions()
    }
}
