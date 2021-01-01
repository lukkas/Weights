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
    @State var reps: Double? = 12
    @State var kilograms: Double? = 80
    @State var rpe: Double? = 8
    
    var body: some View {
        HStack(alignment: .parameterFieldAlignment) {
            ParameterField(
                label: "reps",
                themeColor: .weightYellow,
                value: $reps
            )
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
                Text("Add")
                    .font(.system(
                        size: 16,
                        weight: .semibold
                    ))
                    .accentColor(.contrastLabel)
                    .frame(width: 60, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.theme)
                    )
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
