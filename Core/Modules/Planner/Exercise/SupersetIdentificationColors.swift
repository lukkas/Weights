//
//  SupersetIdentificationColors.swift
//  Core
//
//  Created by Łukasz Kasperek on 28/09/2022.
//

import SwiftUI

extension Color {
    static func forSupersetIdentification(at index: Int) -> Color {
        let colors: [Color] = [
            .weightRed,
            .weightGreen,
            .weightBlue,
            .weightYellow
        ]
        return colors[index % colors.count]
    }
}
