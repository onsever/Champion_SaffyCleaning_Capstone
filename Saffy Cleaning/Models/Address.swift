//
//  Address.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-11.
//

import Foundation

class Address {
    var address: String
    var contactPerson: String
    var contactNumber: String
    var type: String
    var sizes: String
    
    init(address: String, contactPerson: String, contactNumber: String, type: String, sizes: String) {
        self.address = address
        self.contactPerson = contactPerson
        self.contactNumber = contactNumber
        self.type = type
        self.sizes = sizes
    }
}
