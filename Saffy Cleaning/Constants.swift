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
    static let users = "users"
    static let addressImages = "addressImages"
    static let reviews = "reviews"
}


enum UserType : String {
    case user, worker
}

enum UserOrderType : String {
    /* Definition:
     pending: initial state
     applied: worker takes the job
     matched: user accept the worker's apply
     cancelled: user don't accept the worker's apply
     completed: user confirm the order is completed
     */
    case pending, opening, applied, matched, proceeding, completed, cancelled
}
