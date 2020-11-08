//
//  ParameterGauge.swift
//  Core
//
//  Created by Łukasz Kasperek on 25/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ParameterGauge: View {
    let value: String
    let themeColor: Color
    
    var body: some View {
        Text(value)
            .font(.footnote)
            .foregroundColor(.overThemeLabel)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(themeColor.cornerRadius(8))
    }
}

struct ParameterGauge_Previews: PreviewProvider {
    static var previews: some View {
        ParameterGauge(
            value: "RPE",
            themeColor: .paceTheme
        )
    }
}
