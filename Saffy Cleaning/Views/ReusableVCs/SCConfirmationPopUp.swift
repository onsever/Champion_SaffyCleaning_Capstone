//
//  SCConfirmationPopUp.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

protocol SCConfirmationPopUpDelegate: AnyObject {
    func didTapConfirmationButton(_ button: UIButton)
}

class SCConfirmationPopUp: UIViewController {
    
    private let containerView = UIView()
    private let infoLabel = SCTitleLabel(fontSize: 20, textColor: .brandGem)
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .brandGem
        
        return imageView
    }()
    private let orderNumberLabel = SCSubTitleLabel(text: "", isRequired: false, textColor: .brandDark)
    private let descriptionLabel = SCSubTitleLabel(text: "", isRequired: false, textColor: .brandDark)
    private let confirmationButton = SCMainButton(title: "", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    
    public weak var delegate: SCConfirmationPopUpDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
                
        self.imageView.image = UIImage(systemName: "checkmark.circle")
        self.infoLabel.text = "Order Success!"
        self.descriptionLabel.text = "Order has successfully posted.\nCleaner can now see your order in the map posting. You will receive a notification when cleaner take your order!"
        self.confirmationButton.setTitle("OKAY", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureContainerView()
        configureOrderNumberLabel()
        configureImageView()
        configureInfoLabel()
        configureDescriptionLabel()
        configureConfirmationButton()
    }
    
    @objc private func confirmationButtonTapped(_ button: UIButton) {
        confirmationButton.animateWithSpring()
        delegate?.didTapConfirmationButton(button)
        self.dismiss(animated: true, completion: nil)
    }
    
    public func setOrderNumber(orderNumber: String) {
        self.orderNumberLabel.text = "Order number: \(orderNumber)"
    }

}

extension SCConfirmationPopUp {
    
    private func configureContainerView() {
        
        //view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        
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
    
    private func configureOrderNumberLabel() {
        containerView.addSubview(orderNumberLabel)
        orderNumberLabel.font = .urbanistRegular(size: 14)
        
        NSLayoutConstraint.activate([
            orderNumberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            orderNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            orderNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            orderNumberLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureImageView() {
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: orderNumberLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80)
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
    
}
