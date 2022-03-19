//
//  SCEmptyPhotoCell.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-18.
//

import UIKit

protocol SCEmptyPhotoCellDelegate: AnyObject {
    func addPhotoCellTapped(_ gesture: UITapGestureRecognizer)
}

class SCEmptyPhotoCell: UICollectionViewCell {
    
    public static let identifier = "EmptyImageCell"
    public weak var delegate: SCEmptyPhotoCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(systemName: "plus")
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
        configureCellLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func addNewImage(_ gesture: UITapGestureRecognizer) {
        delegate?.addPhotoCellTapped(gesture)
    }
    
    private func configureImageView() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addNewImage(_:)))
        self.addGestureRecognizer(tap)
    }
    
    private func configureCellLayout() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
    }
    
}
