//
//  UserOrder.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-15.
//

import Foundation

class UserOrder: Codable {
    public var id :String
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
    public var workerName: String = ""
    public var workerImageURL: String
    public var userName: String
    public var userId: String
    public var userImageURL: String
    public var isUserCommented: Bool = false
    public var isWorkerCommented: Bool = false
    public var createdAt: String
    public var updatedAt: String
    
    init(date: String,
         time: String,
         duration: Int,
         address: Address,
         pet: String,
         message: String,
         selectedItems: [String],
         tips: Double?,
         totalCost: Double,
         userId: String,
         id: String,
         userName: String,
         workerName: String,
         workerImageURL: String,
         userImageURL: String,
         createdAt: String,
         updatedAt: String
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
        self.id = id
        self.userName = userName
        self.workerName = workerName
        self.workerImageURL = workerImageURL
        self.userImageURL = userImageURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
