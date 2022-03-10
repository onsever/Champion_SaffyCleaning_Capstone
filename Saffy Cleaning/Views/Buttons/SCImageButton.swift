//
//  SCRadioButton.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-07.
//

import UIKit

class SCImageButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.layer.opacity = isSelected ? 1 : 0.5
        }
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

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
        self.isSelected = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.brandGem.cgColor
        self.setImage(UIImage(named: "carpet"), for: .normal)
        self.clipsToBounds = true
    }
    
}
