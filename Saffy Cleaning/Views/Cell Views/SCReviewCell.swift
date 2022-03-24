//
//  SCReviewCell.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-08.
//

import UIKit
import SDWebImage

enum Rating: String {
    case oneStar = "sc_rating_1"
    case twoStar = "sc_rating_2"
    case threeStar = "sc_rating_3"
    case fourStar = "sc_rating_4"
    case fiveStar = "sc_rating_5"
}

class SCReviewCell: UITableViewCell {
    
    public static let identifier = "ReviewCell"
    private let userImageView = SCProfileImageView(cornerRadius: 30)
    private let dateLabel = SCCompletionLabel(title: "Title", titleColor: .brandDark, fontSize: 12)
    private let reviewLabel = SCMainLabel(fontSize: 12, textColor: .brandDark)
    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "sc_star_review")?.withRenderingMode(.alwaysOriginal)
        
        return imageView
    }()
    private var stackView: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.isUserInteractionEnabled = false
        
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
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            userImageView.widthAnchor.constraint(equalToConstant: 60),
            userImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [ratingImageView, reviewLabel])
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 10
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 5)
        
        NSLayoutConstraint.activate([
            ratingImageView.widthAnchor.constraint(equalToConstant: 80),
            ratingImageView.heightAnchor.constraint(equalToConstant: 18),
            reviewLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
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
    
    public func setData(userImage: String, ratingCount: Int, userReview: String, currentDate: String) {
        self.userImageView.sd_setImage(with: URL(string: userImage), completed: nil)
        self.reviewLabel.text = userReview
        self.dateLabel.text = currentDate
        reviewLabel.numberOfLines = 0
        
        switch ratingCount {
        case 1:
            self.ratingImageView.image = UIImage(named: Rating.oneStar.rawValue)?.withRenderingMode(.alwaysOriginal)
        case 2:
            self.ratingImageView.image = UIImage(named: Rating.twoStar.rawValue)
        case 3:
            self.ratingImageView.image = UIImage(named: Rating.threeStar.rawValue)
        case 4:
            self.ratingImageView.image = UIImage(named: Rating.fourStar.rawValue)
        case 5:
            self.ratingImageView.image = UIImage(named: Rating.fiveStar.rawValue)
        default:
            self.ratingImageView.image = UIImage(named: Rating.oneStar.rawValue)?.withRenderingMode(.alwaysOriginal)
        }
    }
    
}
