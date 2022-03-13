//
//  SCOrderCell.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit

class SCOrderCell: UITableViewCell {
    
    public static let identifier = "OrderCell"
    private let titleLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    private let titleValue = SCMainLabel(fontSize: 16, textColor: .brandDark)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleValue)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleValue.heightAnchor.constraint(equalToConstant: 20),
            
            titleValue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleValue.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    public func setData(title: String, value: Double) {
        self.titleLabel.text = title
        self.titleValue.text = String(format: "USD %.2f", value)
    }
    
}
