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
}


enum UserType : String {
    case user, worker
}

enum UserOrderType : String {
    case pending, paymentSuccess, opening, applied, matched, proceeding, completed
}
