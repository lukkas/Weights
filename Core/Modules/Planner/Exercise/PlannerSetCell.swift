//
//  PlannerSupersetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/09/2022.
//

import SwiftUI

struct PlannerSetCell: View {
    @Binding var model: PlannerExercise.Set
    @ObservedObject var repsBatchEditor: ExerciseBatchEditor
    @ObservedObject var weightBatchEditor: ExerciseBatchEditor
    let setIndex: Int
    
    @FocusState private var isRepCountFocused
    @FocusState private var isWeightFocused
    
    var body: some View {
        HStack(spacing: .grid(2)) {
            Text(String(setIndex + 1))
                .padding()
            Spacer()
            Button {
                activeBatchEditor?.batchEditingSwitchDidToggle(at: setIndex)
            } label: {
                if activeBatchEditor?.batchEditedIndices.contains(setIndex) == true {
                    Image(systemName: "checkmark.square.fill")
                } else if activeBatchEditor?.excludedFromBatchEditing.contains(setIndex) == true {
                    Image(systemName: "checkmark.square")
                }
            }
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
                .focused($isWeightFocused)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .textStyle(.pickerAccessory)
        .onChange(of: isRepCountFocused, perform: { newValue in
            repsBatchEditor.focusDidChange(newValue, onIndex: setIndex)
        })
        .onChange(of: model.repCount, perform: { newValue in
            if isRepCountFocused {
                repsBatchEditor.valueDidChange(at: setIndex, value: newValue)
            }
        })
        .onReceive(repsBatchEditor.updates, perform: { update in
            if update.indices.contains(setIndex) {
                model.repCount = update.value
            }
        })
        .onChange(of: isWeightFocused, perform: { newValue in
            weightBatchEditor.focusDidChange(newValue, onIndex: setIndex)
        })
        .onChange(of: model.weight, perform: { newValue in
            if isWeightFocused {
                weightBatchEditor.valueDidChange(at: setIndex, value: newValue)
            }
        })
        .onReceive(weightBatchEditor.updates, perform: { update in
            if update.indices.contains(setIndex) {
                model.weight = update.value
            }
        })
        .transition(.asymmetric(
            insertion: .push(from: .top),
            removal: .push(from: .bottom)
        ))
        .clipped()
        .frame(maxWidth: .infinity, idealHeight: 40)
    }
    
    private var activeBatchEditor: ExerciseBatchEditor? {
        if repsBatchEditor.isActive {
            return repsBatchEditor
        }
        if weightBatchEditor.isActive {
            return weightBatchEditor
        }
        return nil
    }
}

#if DEBUG
//struct PlannerSetCell_Previews: PreviewProvider {
//    struct Wrapper: View {
//        @State var model: PlannerExercise.Set
//        @StateObject var repsBatchEditor = ExerciseBatchEditor()
//        @StateObject var weightBatchEditor = ExerciseBatchEditor()
//
//        var body: some View {
//            PlannerSetCell(
//                model: $model,
//                repsBatchEditor: repsBatchEditor,
//                weightBatchEditor: weightBatchEditor,
//                setIndex: 0
//            )
//        }
//    }
//
//    static var previews: some View {
//        Wrapper(model: .dt_mins)
//            .cellPreview()
//            .frame(maxHeight: 44)
//
//        Wrapper(model: .dt_reps)
//            .cellPreview()
//            .frame(maxHeight: 44)
//    }
//}
#endif
