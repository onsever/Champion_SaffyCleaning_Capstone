//
//  SCWhereView.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-11.
//

import UIKit

protocol SCWhereViewDelegate: AnyObject {
    func didTapEditButtonWhereView(_ button: UIButton)
}

class SCWhereView: UIView {

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
    private let addressView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 25)
    private let contactPersonView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 25)
    private let contactNumberView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 25)
    private let typeView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 25)
    private let sizesView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 25)
    
    public weak var delegate: SCWhereViewDelegate?
    
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
        delegate?.didTapEditButtonWhereView(button)
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
        
        stackView = UIStackView(arrangedSubviews: [addressView, contactPersonView, contactNumberView, typeView, sizesView])
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        addressView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        contactPersonView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        contactNumberView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        typeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sizesView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        for view in stackView.arrangedSubviews {
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
        ])
        
    }
    
    public func setData(address: String, contactPerson: String, contactNumber: String, type: String, sizes: String) -> Bool {
        
        self.addressView.infoLabel.text = "Address"
        self.contactPersonView.infoLabel.text = "Contact person"
        self.contactNumberView.infoLabel.text = "Contact number"
        self.typeView.infoLabel.text = "Type"
        self.sizesView.infoLabel.text = "Sizes"
        
        self.addressView.infoValue.text = address
        self.contactPersonView.infoValue.text = contactPerson
        self.contactNumberView.infoValue.text = contactNumber
        self.typeView.infoValue.text = type
        self.sizesView.infoValue.text = "\(sizes) square feet"
        
        configureStackView()
        
        return true
    }

}
