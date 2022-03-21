//
//  User.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-20.
//

import Foundation
import UIKit

struct User {
    let username: String
    let fullName: String
    let email: String
    let contactNumber: String
    var profileImageUrl: URL?
    let uid: String
    
    public init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.contactNumber = dictionary["contactNumber"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
        
    }
}
