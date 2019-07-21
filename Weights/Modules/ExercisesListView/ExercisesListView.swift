//
//  ExercisesListView.swift
//  Weights
//
//  Created by Łukasz Kasperek on 14/07/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ExercisesListView : View {
    let model: ExercisesListModel
    
    var body: some View {
        List(model.exercises, action: { value in

        }, rowContent: { exercise in
            ExerciseCell(model: exercise)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: .grid(2))
                        .foregroundColor(.secondarySystemBackground)
            )
        })
    }
}

#if DEBUG
struct ExercisesListView_Previews : PreviewProvider {
    static var previews: some View {
        ExercisesListView(model: .sample)
    }
}
#endif
