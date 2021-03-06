//
//  Helpers.swift
//  Saffy Cleaning
//
//  Created by Mark Chan on 16/3/2022.
//

import Foundation

struct DictionaryEncoder {
    static func encode<T>(_ value: T) throws -> [String: Any] where T: Encodable {
        let jsonData = try JSONEncoder().encode(value)
        return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
    }
}

struct ValidateHelper {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct SortUserOrder {
    static func sort(array: [UserOrder]) -> [UserOrder] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatStyle
        let sortedArr = array.sorted { dateFormatter.date(from: $0.updatedAt)! > dateFormatter.date(from: $1.updatedAt)!}
        return sortedArr
    }
}


extension String {
    
    func toDate(withFormat format: String = Constants.dateFormatStyle)-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}

extension Date {
    
    func toString(withFormat format: String = Constants.dateFormatStyle) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
}
