//
//  SCTotalCostView.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit

class SCTotalCostView: UITableViewHeaderFooterView {
    
    public static let identifier = "TotalCostCell"
    private let titleLabel = SCMainLabel(fontSize: 20, textColor: .brandDark)
    private let titleValue = SCMainLabel(fontSize: 20, textColor: .brandDark)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleValue)
        
        titleLabel.text = "Total Cost"
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleValue.heightAnchor.constraint(equalToConstant: 20),
            
            titleValue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleValue.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    public func setData(cost: Double) {
        self.titleValue.text = String(format: "CAD %.2f", cost)
    }
    
}
