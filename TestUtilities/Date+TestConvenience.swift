//
//  Date+TestConvenience.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 29/01/2022.
//

import Foundation

public extension Date {
    static func stubbed(_ day: Int, _ month: Int, _ year: Int) -> Date {
        let components = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: year,
            month: month,
            day: day,
            hour: 12,
            minute: 0,
            second: 0
        )
        return components.date!
    }
}
