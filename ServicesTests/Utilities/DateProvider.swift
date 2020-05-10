//
//  DateProvider.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

class DateProvider {
    var currentDate: Date!
    var getDate: () -> Date {
        return {
            return self.currentDate
        }
    }
}
