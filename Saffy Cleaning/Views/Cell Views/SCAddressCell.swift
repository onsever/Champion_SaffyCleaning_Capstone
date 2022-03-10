//
//  SCAddressCell.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

protocol SCAddressCellDelegate: AnyObject {
    func didTapEditButton(_ button: UIButton)
    func didTapDeleteButton(_ button: UIButton)
    func didTapButton(_ username: String)
}

class SCAddressCell: UICollectionViewCell {
    
    public static let identifier = "AddressCell"
    public weak var delegate: SCAddressCellDelegate?
    private let padding: CGFloat = 20
    private let fontSize: CGFloat = 15
    private var imageArray = [UIImage]()
    
    override var isSelected: Bool {
        didSet {
            self.layer.shadowColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.black.cgColor
        }
    }
    
    private lazy var usernameLabel = SCMainLabel(fontSize: fontSize, textColor: .brandDark)
    private lazy var phoneLabel = SCMainLabel(fontSize: fontSize, textColor: .brandDark)
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SCHousePhotoCell.self, forCellWithReuseIdentifier: SCHousePhotoCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        layout.scrollDirection = .horizontal
        
        return collectionView
    }()
    private lazy var addressLabel = SCMainLabel(fontSize: fontSize, textColor: .brandDark)
    private lazy var houseTypeLabel = SCMainLabel(fontSize: fontSize, textColor: .brandDark)
    private lazy var houseSizeLabel = SCMainLabel(fontSize: fontSize, textColor: .brandDark)
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .brandDark
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        return button
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .brandDark
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCellLayout()
        configureTaskLabel()
        configurePhoneLabel()
        configureCollectionView()
        configureAddressLabel()
        configureHouseTypeLabel()
        configureHouseSizeLabel()
        configureDeleteButton()
        configureEditButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureTaskLabel() {
        contentView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configurePhoneLabel() {
        contentView.addSubview(phoneLabel)
        
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            phoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            phoneLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.clipsToBounds = false
        imageCollectionView.backgroundColor = .white
        contentView.addSubview(imageCollectionView)
        
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureAddressLabel() {
        contentView.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            addressLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureHouseTypeLabel() {
        contentView.addSubview(houseTypeLabel)
        
        NSLayoutConstraint.activate([
            houseTypeLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            houseTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            houseTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            houseTypeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureHouseSizeLabel() {
        contentView.addSubview(houseSizeLabel)
        
        NSLayoutConstraint.activate([
            houseSizeLabel.topAnchor.constraint(equalTo: houseTypeLabel.bottomAnchor, constant: 5),
            houseSizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            houseSizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            houseSizeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureDeleteButton() {
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureEditButton() {
        contentView.addSubview(editButton)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            editButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
            editButton.widthAnchor.constraint(equalToConstant: 25),
            editButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureCellLayout() {
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor

        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }
    
    @objc private func deleteButtonTapped(_ button: UIButton) {
        delegate?.didTapDeleteButton(button)
        delegate?.didTapButton(self.usernameLabel.text!)
    }
    
    @objc private func editButtonTapped(_ button: UIButton) {
        delegate?.didTapEditButton(button)
    }
    
    public func setData(username: String, phoneNumber: String, imageArray: [UIImage], address: String, houseType: String, houseSize: String) {
        self.usernameLabel.text = username
        self.phoneLabel.text = phoneNumber
        self.imageArray = imageArray
        self.addressLabel.text = address
        self.houseTypeLabel.text = houseType
        self.houseSizeLabel.text = "\(houseSize) square feet"
    }
    
}

extension SCAddressCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCHousePhotoCell.identifier, for: indexPath) as? SCHousePhotoCell else { return UICollectionViewCell() }
        
        cell.setData(image: imageArray[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    
}
