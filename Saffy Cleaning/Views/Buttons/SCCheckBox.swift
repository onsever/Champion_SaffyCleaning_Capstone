//
//  SCCheckBox.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-08.
//

import UIKit

class SCCheckBox: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.setImage(UIImage(named: isSelected ? "sc_checkbox_selected" : "sc_checkbox_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(named: "sc_checkbox_selected"), for: .normal)
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
