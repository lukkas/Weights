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
    @State var reps = ""
    @State var kilograms = ""
    @State var rpe = ""
    
    var body: some View {
        HStack(alignment: .parameterFieldAlignment) {
            ParameterField(label: "Reps", value: $reps)
            Text("x")
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.center] }
            ParameterField(label: "kg", value: $kilograms)
            Text("@")
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.center] }
            ParameterField(label: "RPE", value: $rpe)
            Spacer()
            Button(action: {}, label: {
                Image(systemName: "plus")
                    .frame(width: 44, height: 44)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
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
