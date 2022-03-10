//
//  SCProfileImageView.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-08.
//

import UIKit

class SCProfileImageView: UIImageView {
    
    private let shadowLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    public init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        configure()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
                
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        shadowLayer.fillColor = self.backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.systemGray.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 10)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 10.0
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    
}
