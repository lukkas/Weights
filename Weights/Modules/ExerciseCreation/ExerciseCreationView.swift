//
//  ExerciseCreationView.swift
//  Weights
//
//  Created by Łukasz Kasperek on 22/06/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

class ExerciseCreationModel: ObservableObject {
    
}

struct ExerciseCreationView : View {
    @State private var name: String = ""
    @State private var isEditingName: Bool = false
    private let count = ["Reps", "Duration"]
    @State var selectedCount = 0
    private let laterality = [
        "Unilateral / both sides in single set",
        "Unilateral / independent sets",
        "Bilateral"
    ]
    @State var selectedLaterality = 0
    
    @ObservedObject var model: ExerciseCreationViewModel
    
    var body: some View {
        VStack() {
            TextField("Name", text: $model.name, onEditingChanged: {
                self.isEditingName = $0
            })
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Picker("Count", selection: $selectedCount) {
                ForEach(0 ..< count.count) { index in
                    Text(self.count[index])
                }
            }.pickerStyle(SegmentedPickerStyle())
            Picker("Laterality", selection: $selectedLaterality) {
                ForEach(0 ..< laterality.count) { index in
                    Text(self.laterality[index])
                }
            }
        }
    }
}

#if DEBUG
struct ExerciseCreationView_Previews : PreviewProvider {
    static var previews: some View {
        ExerciseCreationView(model: ExerciseCreationViewModel())
    }
}
#endif
