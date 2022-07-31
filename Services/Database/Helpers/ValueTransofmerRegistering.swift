//
//  ValueTransofmerRegistering.swift
//  Services
//
//  Created by Łukasz Kasperek on 31/07/2022.
//

import Foundation

protocol ValueTransformerRegistering: ValueTransformer {
}

extension ValueTransformerRegistering {
    static func register(withName name: String) {
        let transformer = Self()
        ValueTransformer.setValueTransformer(
            transformer,
            forName: NSValueTransformerName(name)
        )
    }
}
