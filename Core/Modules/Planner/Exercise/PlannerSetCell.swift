//
//  PlannerSupersetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/09/2022.
//

import SwiftUI

struct PlannerSetCell: View {
    @Binding var model: PlannerExercise.Set
    
    var body: some View {
        HStack {
            PickerTextField(value: $model.repCount)
                .unitLabel(model.config.metricLabel)
                .fillColor(nil)
                .parameterField(model.config.metricFieldMode)
                .parameterFieldAligned()
            PickerTextField(value: $model.weight)
                .unitLabel(model.config.weightLabel)
                .fillColor(nil)
                .parameterField(.weight)
                .parameterFieldAligned()
        }
        .frame(maxWidth: .infinity)
        .textStyle(.pickerAccessory)
    }
}

struct Underscore: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

#if DEBUG
struct PlannerSetCell_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var model: PlannerExercise.Set
        
        var body: some View {
            PlannerSetCell(model: $model)
        }
    }
    
    static var previews: some View {
        Wrapper(model: .dt_mins)
            .cellPreview()
        
        Wrapper(model: .dt_reps)
            .cellPreview()
    }
}
#endif
