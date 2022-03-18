//
//  Review.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-16.
//

import UIKit

class Review {
    var user: String
    var userImage: UIImage
    var date: String
    var info: String
    var ratingCount: Rating
    
    init(user: String, userImage: UIImage, date: String, info: String, ratingCount: Rating) {
        self.user = user
        self.userImage = userImage
        self.date = date
        self.info = info
        self.ratingCount = ratingCount
    }
}
