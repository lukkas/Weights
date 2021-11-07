//
//  PlannerExerciseView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

protocol PlannerExerciseViewModeling: ObservableObject {
    var name: String { get }
    var variations: [PlannerSetCellModel] { get set }
    func addVariationTapped()
}

struct PlannerExerciseView<Model: PlannerExerciseViewModeling>: View {
    @StateObject var model: Model
    
    var body: some View {
        VStack {
            HStack {
                Text(model.name)
                Spacer()
                Button("Pace") {

                }
                .buttonStyle(.borderedProminent)
                .tint(.weightGreen)
            }
            Divider()
            ForEach($model.variations) { variation in
                PlannerSetCell(model: variation)
            }
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
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)
            .tint(.theme)
        }
        .padding(10)
        .background {
            Color.background
                .cornerRadius(10)
        }
    }
}

struct PlannerExerciseView_Previews: PreviewProvider {
    class Model: PlannerExerciseViewModeling {
        let name: String = "Squat"
        @Published var variations: [PlannerSetCellModel] = [
            PlannerSetCellModel(metric: .reps)
        ]
        
        func addVariationTapped() {
            variations.append(PlannerSetCellModel(metric: .reps))
        }
    }
    
//    struct Wrapper: View {
//        @State var model = Model()
//
//        var body: some View {
//            PlannerExerciseView(model: model)
//        }
//    }

    static var previews: some View {
        PlannerExerciseView(model: Model())
            .cellPreview()
    }
}
