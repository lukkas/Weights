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
//                    .padding(6)
//                    .if(model.exerciseSets.count > 1, transform: { view in
//                        view.overlay(
//                            Underscore()
//                                .stroke(
//                                    Color.forSupersetIdentification(at: model.exerciseSets.firstIndex(of: exerciseSet)!)
//                                )
//                        )
//                    })
//                    .background(
//                        RoundedRectangle(cornerRadius: 12, style: .continuous)
//                            .foregroundColor(.tertiaryBackground)
//                    )
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

//struct PlannerSupersetCell_Previews: PreviewProvider {
//    struct Wrapper: View {
//        @State var model: PlannerSetsCellModel
//        
//        var body: some View {
//            PlannerSetCell(model: $model)
//        }
//    }
//    
//    static var previews: some View {
//        Wrapper(model: .dt_repsAndMins)
//            .cellPreview()
//        
//        Wrapper(model: .dt_reps)
//            .cellPreview()
//    }
//}

//extension PlannerSetsCellModel {
//    static var dt_repsAndMins: Self {
//        PlannerSetsCellModel(
//            exerciseSets: [
//                .init(
//                    metricLabel: "reps",
//                    metricFieldMode: .reps,
//                    weightLabel: "kg"
//                ),
//                .init(
//                    metricLabel: "mins",
//                    metricFieldMode: .time,
//                    weightLabel: "kg"
//                ),
//            ]
//        )
//    }
//    
//    static var dt_reps: Self {
//        PlannerSetsCellModel(
//            exerciseSets: [
//                .init(
//                    metricLabel: "reps",
//                    metricFieldMode: .reps,
//                    weightLabel: "kg"
//                )
//            ]
//        )
//    }
//}
