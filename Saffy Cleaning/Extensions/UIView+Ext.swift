//
//  UIView+Ext.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

extension UIView {
    
    func animateWithSpring() {
        self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
}
