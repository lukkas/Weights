//
//  PlannerSupersetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/09/2022.
//

import SwiftUI

struct PlannerSetCell: View {
    enum Action {
        case remove
    }
    
    @Binding var model: PlannerExercise.Set
    let setIndex: Int
    let onAction: (Action) -> Void
    
    @State private var dragOffset = CGFloat.zero
    
    var body: some View {
        ZStack {
            Color.red
            HStack {
                Text(String(setIndex + 1))
                    .padding()
                Spacer()
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .offset(CGSize(width: dragOffset, height: 0))
            .textStyle(.pickerAccessory)
        }
        .transition(.asymmetric(insertion: .move(edge: .top), removal: .push(from: .bottom)))
        .clipped()
        .gesture(
            DragGesture()
                .onChanged({ value in
                    dragOffset = min(value.translation.width, 0)
                })
                .onEnded({ value in
                    let animatesTowardsLeadingEdge = value.predictedEndTranslation.width < value.translation.width
                    if animatesTowardsLeadingEdge {
                        withAnimation(.easeOut) {
                            let outOfScreenOffset = min(
                                -UIScreen.main.bounds.width,
                                 value.predictedEndTranslation.width
                            )
                            dragOffset = outOfScreenOffset
                            // wait till drag animation ends
                            _ = task {
                                try? await Task.sleep(nanoseconds: 180_000_000)
                            }
                            onAction(.remove)
                        }
                    } else {
                        withAnimation(.easeOut) {
                            dragOffset = 0
                        }
                    }
                })
        )
        .frame(maxWidth: .infinity, idealHeight: 40)
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
            PlannerSetCell(model: $model, setIndex: 0, onAction: { _ in })
        }
    }
    
    static var previews: some View {
        Wrapper(model: .dt_mins)
            .cellPreview()
            .frame(maxHeight: 44)
        
        Wrapper(model: .dt_reps)
            .cellPreview()
            .frame(maxHeight: 44)
    }
}
#endif
