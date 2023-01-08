//
//  BatchEditor.swift
//  Core
//
//  Created by Łukasz Kasperek on 31/12/2022.
//

import Combine
import Foundation

class ExerciseBatchEditor: ObservableObject {
    struct Update: Equatable {
        let indices: IndexSet
        let value: Double?
    }
//    private struct Focus {
//        let focusedIndex: Int
//        var
//    }
    
    private var focusedIndex: Int?
    @Published private(set) var batchEditedIndices = IndexSet()
    var updates: AnyPublisher<Update, Never> {
        updatesSubject.eraseToAnyPublisher()
    }
    private let updatesSubject = PassthroughSubject<Update, Never>()
    
    // next -> jak podac licze pol, ktore sa w to zamieszane
    // inputs
    // -> focus change value -> onChange
    // -> field change value
    // -> send back value change to other fields -> onReceive
    // -> additional controls (including/deincluding field index)
    // -> possibility to send batch editing indicator to other fields
    
    func focusDidChange(_ focused: Bool, onIndex index: Int) {
        if focused {
            focusedIndex = index
            batchEditedIndices = IndexSet(integersIn: (index + 1)...)
        } else if !focused && focusedIndex == index {
            focusedIndex = nil
            batchEditedIndices = IndexSet()
        }
    }
    
    func batchEditingSwitchDidToggle(at index: Int) {
        
    }
    
    func valueDidChange(at index: Int, value: Double?) {
        if focusedIndex != index {
            focusedIndex = index
            batchEditedIndices = IndexSet(integersIn: (index + 1)...)
        }
        let update = Update(indices: batchEditedIndices, value: value)
        updatesSubject.send(update)
    }
}
