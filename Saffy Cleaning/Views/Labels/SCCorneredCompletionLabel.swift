//
//  SCCorneredCompletionLabel.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-17.
//

import UIKit

class SCCorneredCompletionLabel: UILabel {

    private var attributedString: NSMutableAttributedString? = nil
    private var topInset: CGFloat = 2
    private var bottomInset: CGFloat = 2
    private var leftInset: CGFloat = 5
    private var rightInset: CGFloat = 5
    
    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
            self.topInset = top
            self.bottomInset = bottom
            self.leftInset = left
            self.rightInset = right
            super.init(frame: CGRect.zero)
    }
    
    override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        self.textAlignment = .center
        self.isUserInteractionEnabled = true
        self.sizeToFit()
    }

}
