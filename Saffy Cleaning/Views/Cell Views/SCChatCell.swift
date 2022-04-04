//
//  SCChatCell.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-17.
//

import UIKit
import SDWebImage

class SCChatCell: UITableViewCell {
    
    public static let identifier = "ChatCell"
    private let userImageView = SCProfileImageView(cornerRadius: 60 / 2)
    private let userLabel = SCMainLabel(fontSize: 14, textColor: .brandDark)
    private let dateLabel = SCCompletionLabel(title: "Title", titleColor: .brandDark, fontSize: 12)
    private let completionLabel = SCCorneredCompletionLabel(cornerRadius: 8)
    private var horizontalStackView: SCStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureImageView()
        configureUserLabel()
        configureHorizontalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        contentView.addSubview(userImageView)
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            userImageView.widthAnchor.constraint(equalToConstant: 60),
            userImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureUserLabel() {
        contentView.addSubview(userLabel)
        userLabel.font = .urbanistBold(size: 16)
        
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            userLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 15),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView = SCStackView(arrangedSubviews: [completionLabel, dateLabel])
        contentView.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .equalSpacing
        
        for view in horizontalStackView.arrangedSubviews {
            view.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 15),
            horizontalStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 15),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    public func setData(userImage: URL, userName: String, chatMessage: String, completionLabel: Completion, dateLabel: String) {
        self.userImageView.sd_setImage(with: userImage)
        self.userLabel.text = userName
        self.dateLabel.text = dateLabel

        switch completionLabel {
        case .proceeding:

            let attributedText = NSMutableAttributedString(string: completionLabel.rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: UIColor.white, NSAttributedString.Key.font: UIFont.urbanistRegular(size: 13)!])
            self.completionLabel.attributedText = attributedText
            self.completionLabel.backgroundColor = .brandGem

        case .completed:

            let attributedText = NSMutableAttributedString(string: completionLabel.rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistRegular(size: 13)!])
            self.completionLabel.attributedText = attributedText
            self.completionLabel.backgroundColor = .brandLake
        }
    }
    
}
