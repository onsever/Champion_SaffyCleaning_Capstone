//
//  Review.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-16.
//

import UIKit

struct Review {
    var user: String
    var userImage: String
    var date: String
    var info: String
    var ratingCount: Int
    var userType: String
    
    init(user: String, date: String, info: String, ratingCount: Int, userType: String, userImage: String) {
        self.user = user
        self.date = date
        self.info = info
        self.ratingCount = ratingCount
        self.userType = userType
        self.userImage = userImage
    }
}
