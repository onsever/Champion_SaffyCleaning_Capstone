//
//  SCOrderInfoView.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-11.
//

import UIKit

class SCOrderInfoView: UIView {
    
    public let infoLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    public let infoValue = SCMainLabel(fontSize: 16, textColor: .brandDark)
    private var infoValueWidthAnchor: NSLayoutConstraint!
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureInfoLabel() {
        self.addSubview(infoLabel)
        infoLabel.font = .urbanistBold(size: 16)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            infoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: height),
        ])
        
    }
    
    private func configureInfoValue() {
        self.addSubview(infoValue)
        infoValue.font = .urbanistRegular(size: 16)
        infoValue.numberOfLines = 0
        infoValue.lineBreakMode = .byWordWrapping
        infoValue.textAlignment = .right
        NSLayoutConstraint.activate([
            infoValue.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            infoValue.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoValue.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            infoValue.heightAnchor.constraint(equalToConstant: height),
        ])
        
        infoValueWidthAnchor =             infoValue.widthAnchor.constraint(equalToConstant: 200)
        infoValueWidthAnchor.isActive = true
        infoLabel.widthAnchor.constraint(equalToConstant: infoValueWidthAnchor.constant).isActive = true
        
    }
    
}
