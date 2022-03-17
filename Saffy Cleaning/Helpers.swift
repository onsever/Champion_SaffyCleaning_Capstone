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
