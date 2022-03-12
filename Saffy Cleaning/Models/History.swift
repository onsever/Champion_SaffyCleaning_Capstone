//
//  History.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-12.
//

import Foundation

class History {
    
    var address: String
    var date: String
    var status: Status
    
    init(address: String, date: String, status: Status) {
        self.address = address
        self.date = date
        self.status = status
    }
    
}
