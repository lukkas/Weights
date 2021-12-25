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
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List(model.exercises) { exercise in
                    Button {
                        model.pick(exercise)
                    } label: {
                        Text(exercise.exerciseName)
                    }
                    .tint(.label)
                }
                .listStyle(.plain)
                .searchable(text: $searchText)
                .mask(alignment: .bottom, {
                    VStack(spacing: 0) {
                        Color.black
                        LinearGradient(gradient:
                           Gradient(
                               colors: [Color.black, Color.black.opacity(0)]),
                               startPoint: .top, endPoint: .bottom
                           )
                            .frame(height: 50)
                    }
                })
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        Color.clear
                        ForEach(model.pickedExercises) { exercise in
                            PickedExerciseCell(
                                exercise: exercise,
                                onRemoveTapped: {
                                    model.remove(exercise)
                                }
                            )
                        }
                        Color.clear
                    }
                }
                .background(Color.background)
                .frame(height: 100)
            }
        }
        .onAppear(perform: model.handleViewAppeared)
    }
}

protocol ExercisePickerViewModeling: ObservableObject {
    var exercises: [ExerciseCellViewModel] { get }
    var pickedExercises: [ExerciseCellViewModel] { get }
    
    func handleViewAppeared()
    func pick(_ exercise: ExerciseCellViewModel)
    func remove(_ exercise: ExerciseCellViewModel)
}

// MARK: - Design time

class DTExercisePickerViewModel: ExercisePickerViewModeling {
    @Published var exercises: [ExerciseCellViewModel] = ExerciseCellViewModel.make(count: 20)
    @Published var pickedExercises: [ExerciseCellViewModel] = ExerciseCellViewModel.make(count: 3)
    
    func handleViewAppeared() {
        
    }
    
    func pick(_ exercise: ExerciseCellViewModel) {
        
    }
    
    func remove(_ exercise: ExerciseCellViewModel) {
        
    }
}

struct ExercisePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePickerView(model: DTExercisePickerViewModel())
    }
}
