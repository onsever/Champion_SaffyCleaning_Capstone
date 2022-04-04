//
//  SCEmptyAddressCell.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-16.
//

import UIKit

protocol SCEmptyAddressCellDelegate: AnyObject {
    func addNewAddressTapped(_ gesture: UITapGestureRecognizer)
}

class SCEmptyAddressCell: UICollectionViewCell {
    
    public static let identifier = "EmptyAddressCell"
    private let emptyView = UIView()
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .brandDark
        
        return imageView
    }()
    
    private let infoLabel = SCInfoLabel(alignment: .center, fontSize: 14, text: "Add a new address")
    public weak var delegate: SCEmptyAddressCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureEmptyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addNewAddress(_ gesture: UITapGestureRecognizer) {
        delegate?.addNewAddressTapped(gesture)
    }
    
    private func configureEmptyView() {
        contentView.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.backgroundColor = .white
        emptyView.layer.cornerRadius = 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addNewAddress(_:)))
        emptyView.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            emptyView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            emptyView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            emptyView.heightAnchor.constraint(equalToConstant: 240),
        ])
        
        emptyView.addSubview(plusImageView)
        
        NSLayoutConstraint.activate([
            plusImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -18),
            plusImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            plusImageView.heightAnchor.constraint(equalToConstant: 40),
            plusImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        emptyView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: plusImageView.bottomAnchor, constant: 10),
            infoLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
