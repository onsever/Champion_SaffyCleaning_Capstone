//
//  SCHousePhotoCell.swift
//  Prototype
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit
import SDWebImage

class SCHousePhotoCell: UICollectionViewCell {
    
    public static let identifier = "ImageCell"
    
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
        imageView.layer.cornerRadius = 5
        
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
    
    private func configureImageView() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
    }
    
    private func configureCellLayout() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
    }
    
    public func setData(image: UIImage?) {
        self.imageView.image = image
    }
    
    public func setImageFromUrl(urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.main.async {
            self.imageView.sd_setImage(with: url)
        }
    }
    
}
