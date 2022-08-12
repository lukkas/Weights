//
//  DateProvider.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

public class DateProvider {
    public init() {}
    
    public var currentDate: Date!
    public var getDate: () -> Date {
        return {
            return self.currentDate
        }
    }
}
