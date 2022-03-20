//
//  Constants.swift
//  Saffy Cleaning
//
//  Created by Mark Chan on 16/3/2022.
//

import Foundation


struct Constants {
    static let userTypes = "userTypes"
    static let userAddress = "userAddress"
    static let userOrders = "userOrders"
    static let userProfiles = "userProfiles"
    static let addressImages = "addressImages"
    static let userImages = "userImages"
}


enum UserType : String {
    case user, worker
}

enum UserOrderType : String {
    case pending, opening, applied, matched, proceeding, completed, cancelled
}
