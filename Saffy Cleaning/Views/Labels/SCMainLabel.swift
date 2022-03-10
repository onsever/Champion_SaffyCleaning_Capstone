//
//  SCMainLabel.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

class SCMainLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(fontSize: CGFloat, textColor: UIColor) {
        super.init(frame: .zero)
        self.font = .urbanistRegular(size: fontSize)
        self.textColor = textColor
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 4
    }
    
}
