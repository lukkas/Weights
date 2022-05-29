//
//  PlannerExerciseView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerExerciseView<Model: PlannerExerciseViewModeling>: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack {
            HStack {
                Text(model.name)
                Spacer()
                PacePicker(pace: $model.pace)
            }
            Divider()
            ForEach($model.variations) { variation in
                PlannerSetCell(model: variation)
            }
            HStack {
                Button {
                    withAnimation {
                        model.addVariationTapped()
                    }
                } label: {
                    Text(L10n.Planner.Exercise.add)
                        .font(.system(
                            size: 16,
                            weight: .medium,
                            design: .rounded
                        ))
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
                
                Spacer()
            }
        }
        .padding(10)
        .cardDesign()
    }
}

protocol PlannerExerciseViewModeling: ObservableObject, Identifiable, Hashable {
    var name: String { get }
    var pace: UIPacePicker.InputState { get set }
    var variations: [PlannerSetCellModel] { get set }
    func addVariationTapped()
}

extension PlannerExerciseViewModeling {
    static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        return
            lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.variations == rhs.variations
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(variations)
    }
}

// MARK: - Design time

class DTPlannerExerciseViewModel: PlannerExerciseViewModeling {
    init() {
        
    }
    
    let name: String = "Squat"
    @Published var pace = UIPacePicker.InputState()
    @Published var variations: [PlannerSetCellModel] = [
        PlannerSetCellModel(metric: .reps)
    ]
    
    func addVariationTapped() {
        variations.append(PlannerSetCellModel(metric: .reps))
    }
}

struct PlannerExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerExerciseView(model: DTPlannerExerciseViewModel())
            .cellPreview()
    }
}
