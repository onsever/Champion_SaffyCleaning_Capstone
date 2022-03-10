//
//  SCStackView.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

class SCStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .center
        self.spacing = 10
        self.autoresizesSubviews = true
    }
    
}
