//
//  SCHistoryCardCell.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-08.
//

import UIKit

class SCHistoryCardCell: UITableViewCell {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 4
            frame.origin.x += 4
            frame.size.height -= 2 * 5
            frame.size.width -= 2 * 5
            super.frame = frame
        }
    }
    
    public static let identifier = "HistoryCell"
    private let historyIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal)
        
        return imageView
    }()
    private let addressLabel = SCSubTitleLabel(text: "Address", isRequired: false, textColor: .brandDark)
    private let dateLabel = SCSubTitleLabel(text: "Date", isRequired: false, textColor: .brandDark)
    private let completionLabel = SCSubTitleLabel(text: "Completed", isRequired: false, textColor: .brandGem)
    private var stackView: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    private func configure() {
        self.backgroundColor = .lightBrandLake
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        configureIconView()
        configureStackView()
        configureCompletionLabel()
    }
    
    private func configureIconView() {
        self.addSubview(historyIconView)
        
        NSLayoutConstraint.activate([
            historyIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            historyIconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            historyIconView.widthAnchor.constraint(equalToConstant: 40),
            historyIconView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureAddressLabel() {
        self.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            addressLabel.leadingAnchor.constraint(equalTo: historyIconView.trailingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addressLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureDateLabel() {
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: historyIconView.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [addressLabel, dateLabel])
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 20
        
        NSLayoutConstraint.activate([
            addressLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            dateLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: historyIconView.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureCompletionLabel() {
        self.addSubview(completionLabel)
        
        NSLayoutConstraint.activate([
            completionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            completionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func setData(addressTitle: String, date: String, status: Status) {
        self.addressLabel.text = addressTitle
        self.dateLabel.text = date
        
        switch status {
        case .completed:
            self.completionLabel.text = status.rawValue
            self.completionLabel.textColor = .brandDark
        case .proceeding:
            self.completionLabel.text = status.rawValue
            self.completionLabel.textColor = .brandGem
        case .cancelled:
            self.completionLabel.text = status.rawValue
            self.completionLabel.textColor = .brandError
        }

    }
    
    
}
