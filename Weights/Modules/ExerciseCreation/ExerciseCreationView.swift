//
//  ExerciseCreationView.swift
//  Weights
//
//  Created by Łukasz Kasperek on 22/06/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI
import Combine

struct ExerciseCreationView : View {
    @State private var isEditingName: Bool = false
    @ObservedObject var model: ExerciseCreationViewModel
    
    var body: some View {
        VStack() {
            TextField("Name", text: $model.name, onEditingChanged: {
                self.isEditingName = $0
            })
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.grid)
            QuickSelector(model: model.lateralityModel)
            QuickSelector(model: model.muscleGroupModel)
            QuickSelector(model: model.quantityMetricModel)
            Button(action: {
                                
                            }, label: {
                                Text("Cancel")
                                    .font(.callout)
                                    .foregroundColor(.appTheme)
                            })
            Button(action: {
                                
            }, label: {
                Text("Create")
                    .font(.callout)
                    .foregroundColor(Color.systemBackground)
                    .padding(.grid)
                    .background(
                        RoundedRectangle(cornerRadius: .grid)
                            .foregroundColor(.appTheme))
            })
        }
            .padding()
    }
}

#if DEBUG
struct ExerciseCreationView_Previews : PreviewProvider {
    static var previews: some View {
        ExerciseCreationView(model: ExerciseCreationViewModel())
    }
}
#endif
