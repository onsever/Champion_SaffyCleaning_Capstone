//
//  UserOrder.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-15.
//

import Foundation

struct UserOrder: Codable {
    public var id :String =  UUID().uuidString
    public var date: String
    public var time: String
    public var duration: Int
    public var address: Address
    public var pet: String
    public var message: String
    public var selectedItems: [String]
    public var tips: Double?
    public var totalCost: Double
    public var status: String = UserOrderType.pending.rawValue
    public var workerId: String = ""
    public var userId: String
    
    init(date: String,
         time: String,
         duration: Int,
         address: Address,
         pet: String,
         message: String,
         selectedItems: [String],
         tips: Double?,
         totalCost: Double,
         userId: String
    ) {
        self.date = date
        self.time = time
        self.duration = duration
        self.address = address
        self.pet = pet
        self.message = message
        self.selectedItems = selectedItems
        self.tips = tips
        self.totalCost = totalCost
        self.userId = userId
    }
}
