//
//  SCNotificationCell.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-22.
//

import UIKit

class SCNotificationCell: UITableViewCell {
    
    public static let identifier = "NotificationCell"

    private let notificationImage = SCProfileImageView(cornerRadius: 65 / 2)
    private let titleLabel = SCMainLabel(fontSize: 14, textColor: .brandDark)
    private let dateLabel = SCCompletionLabel(title: "Title", titleColor: .brandDark, fontSize: 12)
    private let messageLabel = SCMainLabel(fontSize: 13, textColor: .brandDark)
    private let viewLabel = SCCorneredCompletionLabel(cornerRadius: 8)
    private var horizontalStackView: SCStackView!
    public weak var order: UserOrder?
    public var user: User?
    
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
        if user?.userType == UserType.user.rawValue {
            switch order!.status {
            case UserOrderType.applied.rawValue:
                FirebaseDBService.service.retrieveUserById(id: order!.workerId) { user in
                    // get user obj from here
                    print(user?.userType, user?.uid, user?.fullName)
                }
            case UserOrderType.matched.rawValue:
                FirebaseDBService.service.updateOrderStatus(orderId: order!.id, value: ["status": UserOrderType.completed.rawValue])
            case UserOrderType.completed.rawValue:
                print("order completed")
                // show checkout button
                // after checkout should be review
            default:
                print("notification label clicked")
            }
        }
        else if user?.userType == UserType.worker.rawValue {
            // review pop up?
            // worker only can leave the review
            print("i am worker")
        }
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTappedOn(_:)))
        viewLabel.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            horizontalStackView.leadingAnchor.constraint(equalTo: notificationImage.trailingAnchor, constant: 15),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    public func setData(userOrder: UserOrder, user: User) {
        
        var status = ""
        var message = ""
        
        self.dateLabel.text = userOrder.date
        self.user = user
        
        if user.userType == UserType.user.rawValue {
            self.viewLabel.isUserInteractionEnabled = true
            switch userOrder.status {
            // user placed the order
            case UserOrderType.pending.rawValue:
                message = "You have successfully create a new order for your apartment in \(userOrder.address.street) on \(userOrder.date)."
                self.viewLabel.attributedText = nil
                self.viewLabel.textColor = .white
                self.viewLabel.backgroundColor = .white
            // worker applied the order
            case UserOrderType.applied.rawValue:
                message = "Your order has been applied by a worker. Please click view to checkout the profile."
                self.viewLabel.attributedText = NSMutableAttributedString(string: "View", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistRegular(size: 13)!])
                self.viewLabel.textColor = .black
                self.viewLabel.backgroundColor = .brandYellow
            // user cancelled the order
            case UserOrderType.cancelled.rawValue:
                message = "You cancelled the order."
                self.viewLabel.attributedText = nil
                self.viewLabel.textColor = .white
                self.viewLabel.backgroundColor = .white
            // user matched with worker
            case UserOrderType.matched.rawValue:
                message = "You matched the order with a worker. Please contact the worker through the chatroom for any query."
                self.viewLabel.attributedText = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistRegular(size: 13)!])
                self.viewLabel.textColor = .black
                self.viewLabel.backgroundColor = .green
            // user matched with worker
            case UserOrderType.completed.rawValue:
                message = "Order completed."
                self.viewLabel.attributedText = NSMutableAttributedString(string: "Pay", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistRegular(size: 13)!])
                self.viewLabel.textColor = .black
                self.viewLabel.backgroundColor = .lightGray
            default:
                message = "Unexpected error."
                self.viewLabel.attributedText = nil
                self.viewLabel.textColor = .white
                self.viewLabel.backgroundColor = .white
            }
        }
        else if user.userType == UserType.worker.rawValue {
            self.viewLabel.isUserInteractionEnabled = false
            
            switch userOrder.status {
            // worker applied the order
            case UserOrderType.applied.rawValue:
                message = "You have successfully took the order."
                self.viewLabel.attributedText = nil
                self.viewLabel.textColor = .white
                self.viewLabel.backgroundColor = .white
            // user matched with worker
            case UserOrderType.matched.rawValue:
                message = "The order has been accepted by the owner. Please contact the owner through the chatroom for any query."
                self.viewLabel.attributedText = nil
                self.viewLabel.textColor = .white
                self.viewLabel.backgroundColor = .white
            // user cancelled the order
            case UserOrderType.cancelled.rawValue:
                message = "The order has been cancelled by the user."
                self.viewLabel.attributedText = nil
                self.viewLabel.textColor = .white
                self.viewLabel.backgroundColor = .white
            // order completed
            case UserOrderType.completed.rawValue:
                message = "Order completed. You will receive the fee very soon. Please feel free to leave the comment about this order in review section"
                self.viewLabel.attributedText = NSMutableAttributedString(string: "Review", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistRegular(size: 13)!])
                self.viewLabel.textColor = .black
                self.viewLabel.backgroundColor = .brandYellow
                self.viewLabel.isUserInteractionEnabled = true
            default:
                message = "Unexpected error."
                self.viewLabel.attributedText = nil
                self.viewLabel.textColor = .white
                self.viewLabel.backgroundColor = .white
            }
        }
        
        // order status mapping
        switch userOrder.status {
        case UserOrderType.pending.rawValue:
            status = "posted"
        case UserOrderType.applied.rawValue:
            status = UserOrderType.applied.rawValue
        case UserOrderType.matched.rawValue:
            status = UserOrderType.matched.rawValue
        case UserOrderType.cancelled.rawValue:
            status = UserOrderType.cancelled.rawValue
        case UserOrderType.completed.rawValue:
            status = UserOrderType.completed.rawValue
        default:
            status = ""
        }
        
        self.titleLabel.text = "Order \(status) (\(userOrder.id))"
        self.messageLabel.text = message
        
    }
    
}
