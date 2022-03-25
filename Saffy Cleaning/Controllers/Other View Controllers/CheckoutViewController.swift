//
//  CheckoutViewController.swift
//  Saffy Cleaning
//
//  Created by Philip Chau on 2022-03-25.
//

import Foundation
import UIKit
import PayPalCheckout

class CheckoutViewController: UIViewController {
    
    public var totalCost: String?
    private let confirmationPopUp = SCConfirmationPopUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePayPalCheckout()
        configurePayPalBtn()
        view.backgroundColor = .white
        confirmationPopUp.delegate = self
    }
    
    
    func configurePayPalCheckout() {
        // acc: sb-08udj14512915@personal.example.com
        // pw: j/d05n=A
        Checkout.setCreateOrderCallback { createOrderAction in
            let amount = PurchaseUnit.Amount(currencyCode: .cad, value: self.totalCost!)
            let purchaseUnit = PurchaseUnit(amount: amount)
            let order = OrderRequest(intent: .capture, purchaseUnits: [purchaseUnit])
            
            createOrderAction.create(order: order)
        }
        
        Checkout.setOnApproveCallback { [weak self] approval in
            approval.actions.capture { [weak self] (response, error) in
                guard let self = self else { return }
                
                if error != nil {
                    self.presentAlert(title: "Error!", message: "There is an error with the payment. Please try again!", positiveAction: { action in
                        print("Positive button tapped.")
                    }, negativeAction: nil)
                    
                    return
                }
                
                self.confirmationPopUp.setOrderNumber(orderNumber: String(describing: response!.data.id))
                self.present(self.confirmationPopUp, animated: true, completion: nil)
                
                // MARK: show review popup here
            }
        }
        
        Checkout.setOnCancelCallback {
            print("Order Cancel")
        }
        
        Checkout.setOnErrorCallback {err in
            print(err.error)
        }
        
    }
}

extension CheckoutViewController {
    
    private func configurePayPalBtn() {
        let paymentButton = PayPalButton(label: .checkout)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paymentButton)
        NSLayoutConstraint.activate(
            [
                paymentButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                paymentButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
                paymentButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
                paymentButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
            ]
        )
    }
}

extension CheckoutViewController: SCConfirmationPopUpDelegate {
    
    func didTapConfirmationButton(_ button: UIButton) {
        print("Order confirmation button pressed.")
        self.navigationController?.popViewController(animated: true)
    }
    
}
