//
//  SCPrivacyVC.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-24.
//

import UIKit

class SCPrivacyVC: UIViewController {
    
    private var isPrivacy = false
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextView()
    }
    
    private func configureTextView() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func setText() {
        textView.text = ""
    }
}
