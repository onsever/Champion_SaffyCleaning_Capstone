//
//  SCCircleButton.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

class SCCircleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    public init(image: UIImage, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        
        self.setImage(image, for: .normal)
        self.layer.cornerRadius = cornerRadius
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .brandGem
        self.tintColor = .white
    }
    
}
