//
//  SCOtherDetailsView.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit

protocol SCOtherDetailsViewDelegate: AnyObject {
    func didTapEditButtonOtherView(_ button: UIButton)
}

class SCOtherDetailsView: UIView {

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
    private let petView = SCOrderInfoView(backgroundColor: .lightBrandLake3, height: 25)
    private let messageView = SCVerticalOrderInfoView(backgroundColor: .lightBrandLake3, height: 30)
    private let extraServicesLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    private lazy var serviceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SCExtraServiceCell.self, forCellWithReuseIdentifier: SCExtraServiceCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isUserInteractionEnabled = false
        layout.scrollDirection = .horizontal
        
        return collectionView
    }()
    
    public weak var delegate: SCOtherDetailsViewDelegate?
    private var serviceArray = [ExtraService]()
    private let padding: CGFloat = 20
    
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
        delegate?.didTapEditButtonOtherView(button)
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
        
        stackView = UIStackView(arrangedSubviews: [petView, messageView])
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        
        petView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        messageView.infoValue.numberOfLines = 3
        
        for view in stackView.arrangedSubviews {
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
        ])
        
    }
    
    private func configureCollectionView() {
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        serviceCollectionView.clipsToBounds = false
        serviceCollectionView.backgroundColor = .lightBrandLake3
        self.addSubview(extraServicesLabel)
        self.addSubview(serviceCollectionView)
        
        extraServicesLabel.text = "Extra services"
        extraServicesLabel.font = UIFont.urbanistBold(size: 16)
        
        NSLayoutConstraint.activate([
            extraServicesLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            extraServicesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            extraServicesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
        ])
        
        NSLayoutConstraint.activate([
            serviceCollectionView.topAnchor.constraint(equalTo: extraServicesLabel.bottomAnchor, constant: 0),
            serviceCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            serviceCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            serviceCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    public func setData(pet: String, message: String, selectedItems: [ExtraService]) -> Bool {
        
        self.petView.infoLabel.text = "Pet"
        self.messageView.infoLabel.text = "Message to cleaner"
        
        self.petView.infoValue.text = pet
        self.messageView.infoValue.text = message
        
        self.serviceArray = selectedItems
        
        if selectedItems.count != 0 {
            configureStackView()
            configureCollectionView()
        } else {
            configureStackView()
        }
        
        return true
    }
    
    public func updateCollectionView() {
        self.serviceCollectionView.reloadData()
    }

}

extension SCOtherDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCExtraServiceCell.identifier, for: indexPath) as? SCExtraServiceCell else { return UICollectionViewCell() }
        
        cell.setData(image: serviceArray[indexPath.row].image, name: serviceArray[indexPath.row].name)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
}
