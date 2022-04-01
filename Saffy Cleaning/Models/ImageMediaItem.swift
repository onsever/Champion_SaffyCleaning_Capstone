//
//  ImageMediaItem.swift
//  Saffy Cleaning
//
//  Created by Mark Chan on 30/3/2022.
//

import UIKit
import MessageKit

struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}
