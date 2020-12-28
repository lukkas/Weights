//
//  PlannerSetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerSetCellModel {
    
}

struct PlannerSetCell: View {
    @State var reps = "12"
    @State var kilograms = "80"
    @State var rpe = "8"
    
    var body: some View {
        HStack(alignment: .parameterFieldAlignment) {
            ParameterField(label: "reps", themeColor: .weightYellow, value: $reps)
            Text("x")
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.center] }
            ParameterField(
                label: "kg",
                themeColor: .weightBlue,
                value: $kilograms
            )
            Text("@")
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.center] }
//            ParameterField(
//                label: "RPE",
//                themeColor: .weightRed,
//                value: $rpe
//            )
            Spacer()
            
            Button(action: {}, label: {
                Image(systemName: "plus")
                    .font(.system(
                        size: 21,
                        weight: .semibold,
                        design: .rounded
                    ))
                    .accentColor(.theme)
                    .frame(width: 44, height: 44)
                    .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.center] }
            })
        }
        .background(Color.background)
    }
}

struct PlannerSetCell_Previews: PreviewProvider {
    static var previews: some View {
        PlannerSetCell()
            .cellPreview()
    }
}
