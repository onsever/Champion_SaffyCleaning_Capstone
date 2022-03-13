//
//  SCExtraServiceCell.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import UIKit

class SCExtraServiceCell: UICollectionViewCell {
    
    public static let identifier = "ServiceCell"
    
    override var isSelected: Bool {
        didSet {
            self.layer.shadowColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.black.cgColor
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        
        return imageView
    }()
    
    private let nameLabel = SCMainLabel(fontSize: 16, textColor: .brandDark)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureComponents()
        configureCellLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureComponents() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.sizeToFit()
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.brandGem.cgColor
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    private func configureCellLayout() {
        self.backgroundColor = .lightBrandLake2
        
        
    }
    
    public func setData(image: UIImage?, name: String) {
        self.imageView.image = image
        self.nameLabel.text = name
    }
    
    public func setImageOpacity(opacity: Float) {
        self.imageView.layer.opacity = opacity
    }
    
}
