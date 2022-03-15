//
//  SCVerticalOrderInfoView.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit

class SCVerticalOrderInfoView: UIView {

    public let infoLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    public let infoValue = SCMainLabel(fontSize: 16, textColor: .brandDark)
    private var isCentered: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    private var height: CGFloat = 30
    
    public init(backgroundColor: UIColor, height: CGFloat) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.height = height
        
        configure()
        configureInfoLabel()
        configureInfoValue()
    }
    
    public init(backgroundColor: UIColor, height: CGFloat, isCentered: Bool) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.height = height
        self.isCentered = isCentered
        
        configure()
        configureInfoLabel()
        configureInfoValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureInfoLabel() {
        self.addSubview(infoLabel)
        infoLabel.font = .urbanistBold(size: 16)
        
        if isCentered {
            NSLayoutConstraint.activate([
                infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                infoLabel.heightAnchor.constraint(equalToConstant: height),
            ])
            
        }
        else {
            NSLayoutConstraint.activate([
                infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                infoLabel.heightAnchor.constraint(equalToConstant: height),
            ])
        }
        
    }
    
    private func configureInfoValue() {
        self.addSubview(infoValue)
        infoValue.font = .urbanistRegular(size: 16)
        infoValue.numberOfLines = 2
        
        if isCentered {
            NSLayoutConstraint.activate([
                infoValue.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 5),
                infoValue.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                infoValue.heightAnchor.constraint(equalToConstant: height),
            ])
        }
        else {
            NSLayoutConstraint.activate([
                infoValue.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 5),
                infoValue.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                infoValue.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                infoValue.heightAnchor.constraint(equalToConstant: height),
            ])
        }
        
    }

}
