//
//  UserOrder.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-15.
//

import Foundation

class UserOrder {
    private let id = UUID().uuidString
    public var date: String
    public var time: String
    public var duration: Int
    public var address: Address
    public var pet: String
    public var message: String
    public var selectedItems: [ExtraService]
    public var tips: Double?
    public var totalCost: Double
    
    init(date: String, time: String, duration: Int, address: Address, pet: String, message: String, selectedItems: [ExtraService], tips: Double?, totalCost: Double) {
        self.date = date
        self.time = time
        self.duration = duration
        self.address = address
        self.pet = pet
        self.message = message
        self.selectedItems = selectedItems
        self.tips = tips
        self.totalCost = totalCost
    }
}
