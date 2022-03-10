//
//  SCInfoCell.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

class SCInfoCell: UITableViewCell {
    
    public static let identifier = "InfoCell"
    private let userImageView = SCProfileImageView(cornerRadius: 40)
    private let dateLabel = SCCompletionLabel(title: "Title", titleColor: .brandDark, fontSize: 12)
    private let infoLabel = SCMainLabel(fontSize: 12, textColor: .brandDark)
    private let userLabel = SCTitleLabel(fontSize: 18, textColor: .brandDark)
    private let completionLabel = SCCompletionLabel(cornerRadius: 10)
    private var stackView: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        configureImageView()
        configureStackView()
        configureDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        self.addSubview(userImageView)
        
        NSLayoutConstraint.activate([
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalToConstant: 80),
            userImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [userLabel, infoLabel, completionLabel])
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = UIStackView.noIntrinsicMetric
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 5)
        
        infoLabel.numberOfLines = 1
        
        NSLayoutConstraint.activate([
            userLabel.widthAnchor.constraint(equalToConstant: 75),
            infoLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 30),
            completionLabel.widthAnchor.constraint(equalToConstant: 80),
            completionLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureDateLabel() {
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
        ])

    }
    
    public func setData(userImage: UIImage?, username: String, userReview: String, currentDate: String, status: Bool) {
        self.userImageView.image = userImage?.withRenderingMode(.alwaysOriginal)
        self.userLabel.text = username
        self.infoLabel.text = userReview
        self.dateLabel.text = currentDate
        
        let attributedString = NSMutableAttributedString(string: status ? "Accepted" : "Completed", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.foregroundColor: status ? UIColor.white : UIColor.brandDark, NSAttributedString.Key.underlineColor: status ? UIColor.white : UIColor.brandDark])
        
        self.completionLabel.attributedText = attributedString
        self.completionLabel.backgroundColor = status ? .brandGem : .brandLake
    }

}
