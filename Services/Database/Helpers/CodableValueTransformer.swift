//
//  CodableValueTransformer.swift
//  Services
//
//  Created by Łukasz Kasperek on 31/07/2022.
//

import Foundation

class CodableValueTransformer<T: Codable>: ValueTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let weight = value as? T else { return nil }
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(weight) else { return nil }
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        let decoder = JSONDecoder()
        guard let weight = try? decoder.decode(T.self, from: data) else { return nil }
        return weight
    }
}
