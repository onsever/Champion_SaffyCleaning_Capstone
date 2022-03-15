//
//  Address.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-11.
//

import Foundation

class Address {
    var room: String
    var flat: String
    var street: String
    var building: String
    var district: String
    var contactPerson: String
    var contactNumber: String
    var type: String
    var sizes: String
    
    init(room: String, flat: String, street: String, building: String, district: String, contactPerson: String, contactNumber: String, type: String, sizes: String) {
        self.room = room
        self.flat = flat
        self.street = street
        self.building = building
        self.district = district
        self.contactPerson = contactPerson
        self.contactNumber = contactNumber
        self.type = type
        self.sizes = sizes
    }
}
