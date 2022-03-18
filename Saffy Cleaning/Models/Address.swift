//
//  Address.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-11.
//

import Foundation

class Address: Codable {
    var name: String
    var room: String
    var flat: String
    var street: String
    var postalCode: String
    var building: String
    var district: String
    var contactPerson: String
    var contactNumber: String
    var type: String
    var sizes: String
    var longitude: Double
    var latitude: Double
    
    init(name: String, room: String, flat: String, street: String, postalCode: String, building: String, district: String, contactPerson: String, contactNumber: String, type: String, sizes: String, longitude: Double, latitude: Double) {
        self.name = name
        self.room = room
        self.flat = flat
        self.street = street
        self.postalCode = postalCode
        self.building = building
        self.district = district
        self.contactPerson = contactPerson
        self.contactNumber = contactNumber
        self.type = type
        self.sizes = sizes
        self.longitude = longitude
        self.latitude = latitude
    }
}
