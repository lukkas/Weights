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
                .listStyle(.plain)
                .searchable(text: $model.searchText)
                VStack {
                    HStack {
                        Text(L10n.ExercisePicker.PickedSection.title)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding([.top, .leading])
                        Spacer()
                    }
                    if model.pickedExercises.isEmpty {
                        Text(L10n.ExercisePicker.PickedSection.emptyPlaceholder)
                            .font(.system(size: 16))
                            .foregroundColor(.secondaryLabel)
                            .frame(maxHeight: .infinity)
                    } else {
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
                                    .shadow(color: .black.opacity(0.1), radius: 2)
                                }
                                Color.clear
                            }
                        }
                    }
                }
                .frame(height: 120)
                .background(
                    Color.secondaryBackground
                        .edgesIgnoringSafeArea(.bottom)
                        .shadow(color: .black.opacity(0.1), radius: 4, y: -4)
                )
            }
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
    var searchText: String { get set }
    var addButtonDisabled: Bool { get }
    
    func handleViewAppeared()
    func pick(_ exercise: ExerciseCellViewModel)
    func remove(_ exercise: ExerciseCellViewModel)
    func handleAddTapped()
    func handleCancelTapped()
}

// MARK: - Design time

class DTExercisePickerViewModel: ExercisePickerViewModeling {
    @Published var exercises: [ExerciseCellViewModel]
    @Published var pickedExercises: [ExerciseCellViewModel]
    var searchText: String = ""
    var addButtonDisabled: Bool = false
    
    init(toPickCount: Int, pickedCount: Int) {
        _exercises = .init(initialValue: .make(count: toPickCount))
        _pickedExercises = .init(initialValue: .make(count: pickedCount))
    }
    
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
        ExercisePickerView(
            model: DTExercisePickerViewModel(toPickCount: 20, pickedCount: 3)
        )
        ExercisePickerView(
            model: DTExercisePickerViewModel(toPickCount: 0, pickedCount: 0)
        )
        ExercisePickerView(
            model: DTExercisePickerViewModel(toPickCount: 20, pickedCount: 3)
        )
        .preferredColorScheme(.dark)
    }
}
