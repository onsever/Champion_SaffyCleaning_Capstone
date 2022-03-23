//
//  SCSwitchUserPopUp.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-22.
//

import UIKit
import Firebase

protocol SCSwitchUserPopUpDelegate: AnyObject {
    func dismissPopUp()
}

class SCSwitchUserPopUp: UIViewController {

    private let containerView = UIView()
    private let titleLabel = SCTitleLabel(fontSize: 16, textColor: .brandDark)
    private let yesButton = SCMainButton(title: "YES", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    private let noButton = SCMainButton(title: "NO", backgroundColor: .white, titleColor: .brandError, borderColor: .brandError, cornerRadius: 10, fontSize: nil)
    private var horizontalStackView: SCStackView!
    private var user: User?
    
    public weak var delegate: SCSwitchUserPopUpDelegate?

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContainerView()
        configureStackView()
        setData()
    }
    
    @objc private func yesButtonTapped(_ button: UIButton) {
        
        guard let user = user else {
            return
        }
        
        let databaseRef = Database.database().reference().child("users")
        
        var values = [String: String]()
        
        if user.userType == UserType.user.rawValue {
            values = ["userType": UserType.worker.rawValue]
        }
        else {
            values = ["userType": UserType.user.rawValue]
        }
        
        databaseRef.child(user.uid).updateChildValues(values)
        
        DispatchQueue.main.async {
            self.delegate?.dismissPopUp()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func noButtonTapped(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setData() {
        
        if let user = user {
            
            DispatchQueue.main.async {
                self.titleLabel.text = user.userType == UserType.user.rawValue ? "Switch to Worker mode?" : "Switch to User mode?"
            }
            
        }
    }
    
}


extension SCSwitchUserPopUp {
    
    private func configureContainerView() {
                
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 4
        containerView.layer.borderColor = UIColor.brandGem.cgColor
        containerView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 320),
            containerView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    private func configureStackView() {
        horizontalStackView = SCStackView(arrangedSubviews: [noButton, yesButton])
        containerView.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually
        
        yesButton.addTarget(self, action: #selector(yesButtonTapped(_:)), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(noButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
}
