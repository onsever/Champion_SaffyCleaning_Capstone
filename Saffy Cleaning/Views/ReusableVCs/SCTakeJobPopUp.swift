//
//  SCTakeJobPopUp.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-22.
//

import UIKit

protocol SCTakeJobPopUpDelegate: AnyObject {
    func didTapConfirmationTakeJob(_ button: UIButton)
}

class SCTakeJobPopUp: UIViewController {
    
    private let containerView = UIView()
    private let infoLabel = SCTitleLabel(fontSize: 20, textColor: .brandGem)
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .brandGem
        
        return imageView
    }()
    private let descriptionLabel = SCSubTitleLabel(text: "", isRequired: false, textColor: .brandDark)
    private let confirmationButton = SCMainButton(title: "", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .brandGem
        
        return button
    }()
    
    private let policyView = SCPolicyView()
    
    public weak var delegate: SCTakeJobPopUpDelegate?
    private var isPolicySelected: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
                
        self.imageView.image = UIImage(named: "sc_take_job")!
        self.infoLabel.text = "Take the job?"
        self.descriptionLabel.text = "Make sure you can fulfill the job requirement before you confirm.\nAfter you confirm to take the job, employer would review your profile and you will received further notification to proceed."
        self.confirmationButton.setTitle("CONFIRM", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureContainerView()
        configureImageView()
        configureInfoLabel()
        configureDescriptionLabel()
        configureConfirmationButton()
        configurePolicyView()
        
    }
    
    @objc private func confirmationButtonTapped(_ button: UIButton) {
        confirmationButton.animateWithSpring()
        
        if isPolicySelected {
            delegate?.didTapConfirmationTakeJob(button)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.presentAlert(title: "Please accept the policy.", message: "You need to accept the policy and conditions to proceed.", positiveAction: { action in
                
            }, negativeAction: nil)
        }
    }
    
    @objc private func cancelButtonTapped(_ button: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension SCTakeJobPopUp: SCPolicyViewDelegate {
    
    func didSelectCheckbox(_ button: UIButton) {
        button.isSelected = !button.isSelected
        isPolicySelected = button.isSelected
    }
    
    func didTapPolicy() {
        print("Policy tapped!")
    }
    
    func didTapTermsAndConditions() {
        print("Terms and conditions tapped!")
    }
    
    
}

extension SCTakeJobPopUp {
    
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
            containerView.heightAnchor.constraint(equalToConstant: 380)
        ])
        
    }
    
    private func configureImageView() {
        containerView.addSubview(imageView)
        containerView.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
                
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            cancelButton.heightAnchor.constraint(equalToConstant: 25),
            cancelButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureInfoLabel() {
        containerView.addSubview(infoLabel)
        infoLabel.font = .urbanistBold(size: 20)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            infoLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureDescriptionLabel() {
        containerView.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 6
        descriptionLabel.textAlignment = .left
        descriptionLabel.adjustsFontSizeToFitWidth = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25)
        ])
    }
    
    private func configureConfirmationButton() {
        containerView.addSubview(confirmationButton)
        confirmationButton.addTarget(self, action: #selector(confirmationButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            confirmationButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            confirmationButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            confirmationButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            confirmationButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func configurePolicyView() {
        containerView.addSubview(policyView)
        policyView.delegate = self
        
        NSLayoutConstraint.activate([
            policyView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            policyView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            policyView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            policyView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
