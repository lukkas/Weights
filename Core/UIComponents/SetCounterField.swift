//
//  SetCounterField.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/10/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct SetCounterField: View {
    @Binding var count: Int
    
    var body: some View {
        HStack {
            Text("\(count)x")
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.center] }
        }
        .font(.system(
            size: 18,
            weight: .semibold,
            design: .rounded
        ))
        .border(.cyan, width: 1)
    }
}

struct SetCounterField_Previews: PreviewProvider {
    static var previews: some View {
        SetCounterField(count: .constant(1))
    }
}
