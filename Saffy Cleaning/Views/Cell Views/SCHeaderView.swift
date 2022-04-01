//
//  SCHeaderView.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-31.
//

import UIKit

class SCHeaderView: UITableViewHeaderFooterView {

    public static let identifier = "HeaderCell"
    private let titleLabel = SCMainLabel(fontSize: 20, textColor: .brandDark)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        
        titleLabel.textColor = .brandDark
        titleLabel.font = UIFont.urbanistBold(size: 18)!
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    public func setData(title: String) {
        self.titleLabel.text = title
    }
    
    public func setFontSize(fontSize: CGFloat) {
        self.titleLabel.font = UIFont.urbanistBold(size: fontSize)!
    }

}
