//
//  UIViewController+Ext.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, positiveAction: ((_ action: UIAlertAction) -> Void)?, negativeAction: ((_ action: UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if positiveAction == nil && negativeAction == nil {
            print("Both positive and negative actions can't be nil.")
            return
        }
        
        if let positiveAction = positiveAction {
            let positiveAction = UIAlertAction(title: "OK", style: .default) { action in

                positiveAction(action)
                alertController.dismiss(animated: true, completion: nil)
            }
            
            positiveAction.setValue(UIColor.systemGreen, forKey: "titleTextColor")
            alertController.addAction(positiveAction)
        }
        
        if let negativeAction = negativeAction {
            let negativeAction = UIAlertAction(title: "Cancel", style: .cancel) { action in

                negativeAction(action)
                alertController.dismiss(animated: true, completion: nil)
            }
            
            negativeAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
            alertController.addAction(negativeAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
