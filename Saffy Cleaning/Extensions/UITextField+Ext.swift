//
//  UITextField+Ext.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-24.
//

import UIKit

extension UITextField {
    
    func validateTextField() -> String? {
        if self.text == "" {
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
            self.layer.add(animation, forKey: "shaking_animation")
            self.becomeFirstResponder()
            self.layer.borderColor = UIColor.brandError.cgColor
            
            return nil
        }
        
        self.resignFirstResponder()
        self.layer.borderColor = UIColor.brandGem.cgColor
        self.layer.removeAnimation(forKey: "shaking_animation")
        return self.text
    }
    
}
