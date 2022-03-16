//
//  SCWhenView.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-10.
//

import UIKit

protocol SCWhenViewDelegate: AnyObject {
    func didTapEditButtonWhenView(_ button: UIButton)
}

class SCWhenView: UIView {
    
    private let titleLabel = SCTitleLabel(fontSize: 20, textColor: .brandGem)
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .brandGem
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        return button
    }()
    public var stackView = UIStackView()
    private let dateView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 18)
    private let timeView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 18)
    private let durationView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 18)
    
    public weak var delegate: SCWhenViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public init(title: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        
        configure()
        configureTitleLabel()
        configureEditButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func editButtonTapped(_ button: UIButton) {
        delegate?.didTapEditButtonWhenView(button)
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 15
        self.backgroundColor = .lightBrandLake3
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }
    
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.font = .urbanistBold(size: 20)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureEditButton() {
        self.addSubview(editButton)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 20),
            editButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureStackView() {
        
        stackView = UIStackView(arrangedSubviews: [dateView, timeView, durationView])
        
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
        ])
        
    }
    
    public func setData(date: String, time: String, duration: Int) -> Bool {
        
        self.dateView.infoLabel.text = "Date"
        self.timeView.infoLabel.text = "Time"
        self.durationView.infoLabel.text = "Duration"
        
        self.dateView.infoValue.text = date
        self.timeView.infoValue.text = time
        self.durationView.infoValue.text = "\(duration) hours"
        
        configureStackView()
        
        return true
    }
    
}
