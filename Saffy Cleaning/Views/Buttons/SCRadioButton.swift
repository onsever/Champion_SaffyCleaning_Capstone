//
//  SCRadioButton.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-08.
//

import UIKit

class SCRadioButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.setImage(UIImage(named: isSelected ? "sc_radio_selected": "sc_radio_unselected"), for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
