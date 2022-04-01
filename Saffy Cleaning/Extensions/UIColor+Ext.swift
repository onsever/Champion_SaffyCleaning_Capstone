//
//  UIColor+Ext.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

extension UIColor {
    
    static let brandGem = UIColor(red: 0.02, green: 0.68, blue: 0.75, alpha: 1.00)
    
    static let brandYellow = UIColor(red: 0.95, green: 0.80, blue: 0.03, alpha: 1.00)
    
    static let brandLake = UIColor(red: 0.55, green: 0.80, blue: 0.95, alpha: 1.00)
    
    static let brandDark = UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 1.00)
    
    static let brandError = UIColor(red: 0.75, green: 0.06, blue: 0.02, alpha: 1.00)
    
    static let lightBrandLake = UIColor(red: 0.81, green: 0.87, blue: 0.91, alpha: 1.00)
    
    static let lightBrandLake2 = UIColor(red: 0.68, green: 0.84, blue: 0.86, alpha: 1.00)
    
    static let lightBrandLake3 = UIColor(red: 0.71, green: 0.86, blue: 0.88, alpha: 1.00)
    
    static let brandDarkGray = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
    
    static var primary: UIColor {
        return self.brandGem
    }
    
    static var incomingMessage: UIColor {
        return self.brandLake
    }
    
}
