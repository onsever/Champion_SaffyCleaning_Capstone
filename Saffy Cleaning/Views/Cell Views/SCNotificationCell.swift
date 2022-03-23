//
//  SCNotificationCell.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-22.
//

import UIKit

protocol SCNotificationCellDelegate: AnyObject {
    func userTappedOnView()
}

class SCNotificationCell: UITableViewCell {
    
    public static let identifier = "NotificationCell"

    private let notificationImage = SCProfileImageView(cornerRadius: 65 / 2)
    private let titleLabel = SCMainLabel(fontSize: 14, textColor: .brandDark)
    private let dateLabel = SCCompletionLabel(title: "Title", titleColor: .brandDark, fontSize: 12)
    private let messageLabel = SCMainLabel(fontSize: 13, textColor: .brandDark)
    private let viewLabel = SCCorneredCompletionLabel(cornerRadius: 8)
    private var horizontalStackView: SCStackView!
    public weak var delegate: SCNotificationCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureImageView()
        configureUserLabel()
        configureChatLabel()
        configureHorizontalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func viewDidTappedOn(_ gesture: UITapGestureRecognizer) {
        delegate?.userTappedOnView()
    }
    
    private func configureImageView() {
        contentView.addSubview(notificationImage)
        notificationImage.backgroundColor = .white
        notificationImage.image = UIImage(systemName: "list.bullet.circle")
        notificationImage.tintColor = .brandGem
        
        NSLayoutConstraint.activate([
            notificationImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            notificationImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            notificationImage.widthAnchor.constraint(equalToConstant: 65),
            notificationImage.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func configureUserLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = .urbanistBold(size: 15)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: notificationImage.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func configureChatLabel() {
        contentView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: notificationImage.trailingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView = SCStackView(arrangedSubviews: [viewLabel, dateLabel])
        contentView.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .equalSpacing
        
        for view in horizontalStackView.arrangedSubviews {
            view.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor).isActive = true
        }
        
        viewLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        let attributedText = NSMutableAttributedString(string: "View", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistRegular(size: 13)!])
        self.viewLabel.attributedText = attributedText
        self.viewLabel.backgroundColor = .brandYellow
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTappedOn(_:)))
        viewLabel.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            horizontalStackView.leadingAnchor.constraint(equalTo: notificationImage.trailingAnchor, constant: 15),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    public func setData(userOrder: UserOrder) {
        
        self.dateLabel.text = userOrder.date
        
        if userOrder.status == "pending" {
            self.titleLabel.text = "Order posted (\(userOrder.id))"
            self.messageLabel.text = "You have successfully create a new order for your apartment in \(userOrder.address.street) on \(userOrder.date)."
            self.viewLabel.textColor = .white
            self.viewLabel.isUserInteractionEnabled = false
            self.viewLabel.attributedText = nil
            self.viewLabel.backgroundColor = .white
        }
        else if userOrder.status == "matched" {
            self.titleLabel.text = "Order update (\(userOrder.id))"
            self.messageLabel.text = "Someone wants to take your job. Let's review their profile to decide do you want their service or not."
            self.viewLabel.isUserInteractionEnabled = true
        }
        else if userOrder.status == "completed" {
            self.titleLabel.text = "Order completed (\(userOrder.id))"
            self.messageLabel.text = "Your order successfully been completed. Thank you for working with us!"
            self.viewLabel.textColor = .white
            self.viewLabel.isUserInteractionEnabled = false
            self.viewLabel.attributedText = nil
            self.viewLabel.backgroundColor = .white
        }
        
        /*
        switch status {
        case .pending:
            break
        case .opening:
            break
        case .applied:
            break
        case .matched:
            self.titleLabel.text = "Order update (\(userOrder.id))"
            self.messageLabel.text = "Sella wants to take your job. Let's review her profile to decide do you want her service or not."
            break
        case .proceeding:
            self.titleLabel.text = "Order posted (\(userOrder.id))"
            self.messageLabel.text = "You have successfully create a new order for your apartment in \(userOrder.address.street) on \(userOrder.date)."
            break
        case .completed:
            self.titleLabel.text = "Order completed (\(userOrder.id))"
            self.messageLabel.text = "Your order successfully been completed. Thank you for working with us!"
            break
        case .cancelled:
            break
        }*/
        
        
    }

}
