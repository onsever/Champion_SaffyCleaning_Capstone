//
//  Review.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-16.
//

import UIKit

struct Review {
    var reviewerId: String
    var reviewerImageUrl: String
    var date: String
    var info: String
    var ratingCount: Int
    var revieweeUserType: String
    
    init(reviewerId: String, date: String, info: String, ratingCount: Int, revieweeUserType: String, reviewerImageUrl: String) {
        self.reviewerId = reviewerId
        self.date = date
        self.info = info
        self.ratingCount = ratingCount
        self.revieweeUserType = revieweeUserType
        self.reviewerImageUrl = reviewerImageUrl
    }
}
