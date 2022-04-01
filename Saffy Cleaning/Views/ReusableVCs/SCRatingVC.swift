//
//  SCRatingVC.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-24.
//

import UIKit
import SDWebImage
import Cosmos

protocol SCRatingVCDelegate: AnyObject {
    func ratingButtonTapped(review: Review, revieweeId: String, orderId: String)
}

class SCRatingVC: UIViewController {
    
    private let containerView = UIView()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .brandGem
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private let titleLabel = SCSubTitleLabel(text: "", isRequired: false, textColor: .brandDark)
    private let nameLabel = SCSubTitleLabel(text: "", isRequired: false, textColor: .brandDark)
    private let confirmationButton = SCMainButton(title: "OKAY", backgroundColor: .brandYellow, titleColor: .brandDark, cornerRadius: 10, fontSize: nil)
    private let scoreLabel = SCSubTitleLabel(text: "", isRequired: false, textColor: .brandDark)
    private let messageLabel = SCSubTitleLabel(text: "", isRequired: false, textColor: .brandDark)
    private let messageTextField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.brandGem.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 10
        textView.autocorrectionType = .no
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
        textView.textColor = .brandDark
        
        return textView
    }()
    
    private lazy var ratingView: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rating = 3
        
        return view
    }()
    
    public weak var delegate: SCRatingVCDelegate?
    public var review: Review
    public var revieweeId: String
    public var orderId: String
    
    public init(user: User, review: Review, revieweeId: String, orderId: String) {
        self.review = review
        self.revieweeId = revieweeId
        self.orderId = orderId
        self.titleLabel.text = user.userType == UserType.user.rawValue ? "Do you like working for \(user.fullName)?" : "Do you like the \(user.fullName) service?"
        self.imageView.sd_setImage(with: user.profileImageUrl)
        self.nameLabel.text = user.fullName
        self.scoreLabel.text = "Score \(user.fullName) from 1-5 star"
        self.messageLabel.text = "Message to the user"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureContainerView()
        configureTitleLabel()
        configureImageView()
        configureNameLabel()
        configureScoreLabel()
        configureRatingView()
        configureMessageLabel()
        configureMessageTextField()
        configureConfirmationButton()
    }
    
    @objc private func confirmationButtonTapped(_ button: UIButton) {
        confirmationButton.animateWithSpring()
        
        if messageTextField.text == "" {
            self.presentAlert(title: "Warning", message: "Please leave the comment below.", positiveAction: {action in return}, negativeAction: {action in return})
        }else{
            self.review.info = messageTextField.text
            self.review.ratingCount = Int(ratingView.rating)
            delegate?.ratingButtonTapped(review: self.review, revieweeId: revieweeId, orderId: self.orderId)
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension SCRatingVC {
    
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
            containerView.heightAnchor.constraint(equalToConstant: 420)
        ])
        
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.font = .urbanistRegular(size: 16)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func configureImageView() {
        containerView.addSubview(imageView)
        imageView.layer.cornerRadius = 40
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureNameLabel() {
        containerView.addSubview(nameLabel)
        nameLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureScoreLabel() {
        containerView.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            scoreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            scoreLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureRatingView() {
        containerView.addSubview(ratingView)
        
        ratingView.didTouchCosmos = { rating in
            print("Rating \(rating)")
        }
        
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            ratingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
        ])
    }
    
    private func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            messageLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureMessageTextField() {
        containerView.addSubview(messageTextField)
        
        NSLayoutConstraint.activate([
            messageTextField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            messageTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            messageTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            messageTextField.heightAnchor.constraint(equalToConstant: 70)
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
