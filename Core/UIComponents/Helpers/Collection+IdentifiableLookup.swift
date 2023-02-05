//
//  Collection+IdentifiableLookup.swift
//  Core
//
//  Created by Łukasz Kasperek on 22/01/2023.
//

import Foundation

extension Collection where Element: Identifiable {
    func first(matchingIdOf element: Element) -> Element? {
        return first(where: { element.id == $0.id })
    }
    
    func firstIndex(matchingIdOf element: Element) -> Index? {
        return firstIndex(where: { element.id == $0.id })
    }
}
