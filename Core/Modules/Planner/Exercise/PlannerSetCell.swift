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
    @ObservedObject var batchEditor: ExerciseBatchEditor
    let setIndex: Int
    let onAction: (Action) -> Void
    
    @State private var dragOffset = CGFloat.zero
    @FocusState private var isRepCountFocused
    
    var body: some View {
        ZStack {
            Color.red
            HStack(spacing: .grid(2)) {
                Text(String(setIndex + 1))
                    .padding()
                Spacer()
//                Image(systemName: "square.stack.3d.up.fill")
                PickerTextField(value: $model.repCount)
                    .unitLabel(model.config.metricLabel)
                    .highlightStyle(.text)
                    .fillColor(nil)
                    .parameterField(model.config.metricFieldMode)
                    .parameterFieldAligned()
                    .focused($isRepCountFocused)
                PickerTextField(value: $model.weight)
                    .unitLabel(model.config.weightLabel)
                    .highlightStyle(.text)
                    .fillColor(nil)
                    .parameterField(.weight)
                    .parameterFieldAligned()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .offset(CGSize(width: dragOffset, height: 0))
            .textStyle(.pickerAccessory)
        }
        .onChange(of: isRepCountFocused, perform: { newValue in
            batchEditor.focusDidChange(newValue, onIndex: setIndex)
        })
        .onChange(of: model.repCount, perform: { newValue in
            if isRepCountFocused {
                batchEditor.valueDidChange(at: setIndex, value: newValue)
            }
        })
        .onReceive(batchEditor.updates, perform: { update in
            if update.indices.contains(setIndex) {
                model.repCount = update.value
            }
        })
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

#if DEBUG
struct PlannerSetCell_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var model: PlannerExercise.Set
        @StateObject var batchEditor = ExerciseBatchEditor()
        
        var body: some View {
            PlannerSetCell(
                model: $model,
                batchEditor: batchEditor,
                setIndex: 0,
                onAction: { _ in }
            )
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
