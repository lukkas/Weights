//
//  ExercisePickerView.swift
//  Core
//
//  Created by Łukasz Kasperek on 21/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ExercisePickerView<Model: ExercisePickerViewModeling>: View {
    @ObservedObject var model: Model
    
    var body: some View {
        List(model.exercises, selection: $model.selection) { exercise in
            Text(exercise.exerciseName)
        }
        .onAppear(perform: model.handleViewAppeared)
    }
}

protocol ExercisePickerViewModeling: ObservableObject {
    var exercises: [ExerciseCellViewModel] { get }
    var selection: Set<ExerciseCellViewModel> { get set }
    var pickedExercises: [ExerciseCellViewModel] { get }
    
    func handleViewAppeared()
}

// MARK: - Design time

class DTExercisePickerViewModel: ExercisePickerViewModeling {
    @Published var exercises: [ExerciseCellViewModel] = ExerciseCellViewModel.make(count: 3)
    @Published var selection: Set<ExerciseCellViewModel> = [] {
        didSet {
            pickedExercises = Array(selection)
        }
    }
    @Published var pickedExercises: [ExerciseCellViewModel] = []
    
    func handleViewAppeared() {
        
    }
}

struct ExercisePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePickerView(model: DTExercisePickerViewModel())
    }
}
