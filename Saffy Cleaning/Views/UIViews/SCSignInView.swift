//
//  SCSignInView.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-07.
//

import UIKit

class SCSignInView: UIView {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .brandDark
        
        return label
    }()
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        logoImageView.image = image
        contentLabel.text = title
        
        configure()
        layoutComponents()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }
    
    private func layoutComponents() {
        self.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        self.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 20),
            contentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            contentLabel.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
    }
}
