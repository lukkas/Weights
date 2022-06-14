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
        NavigationStack {
            VStack(spacing: 0) {
                List(model.exercises) { exercise in
                    Button {
                        model.pick(exercise)
                    } label: {
                        Text(exercise.exerciseName)
                            .textStyle(.listItem)
                    }
                    .tint(.label)
                }
                .listStyle(.grouped)
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
                .frame(height: 100)
            }
            .background(Color.secondaryBackground)
            .navigationTitle(L10n.ExercisePicker.NavBar.pickExercises)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.Common.cancel) {
                        model.handleCancelTapped()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.ExercisePicker.NavBar.add) {
                        model.handleAddTapped()
                    }
                    .disabled(model.addButtonDisabled)
                }
            })
        }
        .onAppear(perform: model.handleViewAppeared)
    }
}

protocol ExercisePickerViewModeling: ObservableObject {
    var exercises: [ExerciseCellViewModel] { get }
    var pickedExercises: [ExerciseCellViewModel] { get }
    var addButtonDisabled: Bool { get }
    
    func handleViewAppeared()
    func pick(_ exercise: ExerciseCellViewModel)
    func remove(_ exercise: ExerciseCellViewModel)
    func handleAddTapped()
    func handleCancelTapped()
}

// MARK: - Design time

class DTExercisePickerViewModel: ExercisePickerViewModeling {
    @Published var exercises: [ExerciseCellViewModel] = ExerciseCellViewModel.make(count: 20)
    @Published var pickedExercises: [ExerciseCellViewModel] = ExerciseCellViewModel.make(count: 3)
    var addButtonDisabled: Bool = false
    
    func handleViewAppeared() {
        
    }
    
    func pick(_ exercise: ExerciseCellViewModel) {
        
    }
    
    func remove(_ exercise: ExerciseCellViewModel) {
        
    }
    
    func handleAddTapped() {
        
    }
    
    func handleCancelTapped() {
        
    }
}

struct ExercisePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePickerView(model: DTExercisePickerViewModel())
        
        ExercisePickerView(model: DTExercisePickerViewModel())
            .preferredColorScheme(.dark)
    }
}
