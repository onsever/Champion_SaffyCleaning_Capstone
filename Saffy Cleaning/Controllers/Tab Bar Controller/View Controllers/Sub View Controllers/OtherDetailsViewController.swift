//
//  OtherDetailsViewController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit

protocol OtherDetailsViewDelegate: AnyObject {
    func addOtherDetails(pet: String, message: String, tips: String)
}

class OtherDetailsViewController: UIViewController {
    
    private let petView = SCVerticalOrderInfoView(backgroundColor: .lightBrandLake2, height: 20)
    private var horizontalStackView: SCStackView!
    private let yesButton = SCRadioButtonView(title: "Yes")
    private let noButton = SCRadioButtonView(title: "No")
    private let quantityTextField = SCTextField(placeholder: "Describe quantity and type of pet in the place.")
    private let messageLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    private let messageTextField = SCTextField(placeholder: "Leave a message to the cleaner...")
    
    public weak var delegate: OtherDetailsViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configurePetView()
        configureHorizontalStackView()
        configureQuantityTextField()
        configureMessageLabel()
        configureMessageTextField()
        
        yesButton.delegate = self
        noButton.delegate = self
    }
    
    @objc private func okButtonTapped(_ button: UIBarButtonItem) {
        
        let pet = quantityTextField.text!
        let message = messageTextField.text!
        
        delegate?.addOtherDetails(pet: pet, message: message, tips: "USD 10")
    }
    

}

extension OtherDetailsViewController: SCRadioButtonViewDelegate {
    
    func didTapRadioButton(_ button: UIButton) {
        
        if yesButton.radioButton.isSelected {
            noButton.radioButton.isSelected = false
        }
        
        if noButton.radioButton.isSelected {
            yesButton.radioButton.isSelected = false
        }
        
        switch button {
        case yesButton.radioButton:
            print("Yes Button clicked")
            yesButton.radioButton.isSelected = true
        case noButton.radioButton:
            print("No button clicked")
            noButton.radioButton.isSelected = true
        default:
            break
        }
    }
    
    
}

extension OtherDetailsViewController {
    
    private func configureViewController() {
        
        view.backgroundColor = .lightBrandLake2
        title = "Other details"
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(okButtonTapped(_:)))
        okButton.tintColor = .brandDark
        okButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.urbanistRegular(size: 18)!], for: .normal)
        navigationItem.leftBarButtonItem = okButton
    }
    
    private func configurePetView() {
        view.addSubview(petView)
        
        petView.infoLabel.text = "Pets"
        petView.infoValue.text = "Is/are there pets in the place?"
        
        NSLayoutConstraint.activate([
            petView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            petView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            petView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            petView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configureHorizontalStackView() {
        horizontalStackView = SCStackView(arrangedSubviews: [yesButton, noButton])
        view.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually
                
        NSLayoutConstraint.activate([
            yesButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            noButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: petView.bottomAnchor, constant: 20),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureQuantityTextField() {
        view.addSubview(quantityTextField)
        
        NSLayoutConstraint.activate([
            quantityTextField.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 10),
            quantityTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            quantityTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            quantityTextField.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func configureMessageLabel() {
        view.addSubview(messageLabel)
        messageLabel.text = "Message to cleaner"
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureMessageTextField() {
        view.addSubview(messageTextField)
        
        NSLayoutConstraint.activate([
            messageTextField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            messageTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            messageTextField.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
}

/*
 private func configureYesView() {
     view.addSubview(yesButton)
     view.addSubview(noButton)
     
     NSLayoutConstraint.activate([
         yesButton.topAnchor.constraint(equalTo: petView.bottomAnchor, constant: 40),
         yesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
         yesButton.widthAnchor.constraint(equalToConstant: 15),
         yesButton.heightAnchor.constraint(equalToConstant: 15),
         
         noButton.topAnchor.constraint(equalTo: petView.bottomAnchor, constant: 40),
         noButton.leadingAnchor.constraint(equalTo: yesButton.trailingAnchor, constant: 30),
         yesButton.widthAnchor.constraint(equalToConstant: 15),
         yesButton.heightAnchor.constraint(equalToConstant: 15)
     ])
 }
 */
