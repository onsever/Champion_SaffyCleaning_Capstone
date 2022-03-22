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
    
    public let checkBox = SCCheckBox(frame: .zero)
    public weak var delegate: SCPolicyViewDelegate?
    private let infoLabel = SCInfoLabel(alignment: .center, fontSize: 18, text: "Accept the Privacy Policy and Terms & Conditions.")

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
        
        NSLayoutConstraint.activate([
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            checkBox.widthAnchor.constraint(equalToConstant: 15),
            checkBox.heightAnchor.constraint(equalToConstant: 15),
            
            infoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            infoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(policyAction(_:)))
        
        self.checkBox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        self.infoLabel.addGestureRecognizer(tap)
        
    }
    
    @objc private func checkBoxTapped(_ button: UIButton) {
        delegate?.didSelectCheckbox(button)
    }
    
    @objc private func policyAction(_ gesture: UITapGestureRecognizer) {
        
        let policyRange = (infoLabel.text! as NSString).range(of: "Privacy Policy")
        
        let termsRange = (infoLabel.text! as NSString).range(of: "Terms & Conditions.")
        
        if gesture.didTapAttributedTextInLabel(label: infoLabel, inRange: policyRange) {
            delegate?.didTapPolicy()
        } else if gesture.didTapAttributedTextInLabel(label: infoLabel, inRange: termsRange) {
            delegate?.didTapTermsAndConditions()
        } else {
            print("Tapped none")
        }
        
    }
}
