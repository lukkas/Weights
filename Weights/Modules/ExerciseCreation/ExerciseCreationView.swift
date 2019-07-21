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
    @ObjectBinding var model: ExerciseCreationViewModel
    
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
            HStack(spacing: 0) {
                Button(action: {
                    
                }, label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.appTheme)
                })
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("Create")
                        .font(.callout)
                        .foregroundColor(Color.systemBackground)
                        .padding(.grid)
                        .background(
                            RoundedRectangle(cornerRadius: .grid(2), style: .circular)
                                .foregroundColor(.appTheme))
                })
            }.padding(.top, .grid)
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
