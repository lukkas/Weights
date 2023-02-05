//
//  BatchEditor.swift
//  Core
//
//  Created by Łukasz Kasperek on 31/12/2022.
//

import Combine
import Foundation
import SwiftUI

class ExerciseBatchEditor: ObservableObject {    
    private var focusedIndex: Int?
    @Published private(set) var batchEditedIndices = IndexSet()
    @Published private(set) var excludedFromBatchEditing = IndexSet()
    var isActive: Bool { focusedIndex != nil }
    private var sets: Binding<[Double?]>
    
    init(sets: Binding<[Double?]>) {
        self.sets = sets
    }
    
    func focusDidChange(_ focused: Bool, onIndex index: Int) {
        if focused {
            focusedIndex = index
            batchEditedIndices = IndexSet(integersIn: (index + 1)...)
            for excludedIndex in findIndicesToExclude() {
                batchEditedIndices.remove(excludedIndex)
                excludedFromBatchEditing.insert(excludedIndex)
            }
        } else if !focused && focusedIndex == index {
            focusedIndex = nil
            batchEditedIndices = IndexSet()
            excludedFromBatchEditing = IndexSet()
        }
    }
    
    private func findIndicesToExclude() -> [Int] {
        guard let focusedIndex else { return [] }
        let sets = sets.wrappedValue
        return sets.indices.compactMap { index -> Int? in
            if focusedIndex >= index { return nil }
            if sets[focusedIndex] == sets[index] { return nil }
            return index
        }
    }
    
    func batchEditingSwitchDidToggle(at index: Int) {
        if batchEditedIndices.contains(index) {
            batchEditedIndices.remove(index)
            excludedFromBatchEditing.insert(index)
        } else {
            batchEditedIndices.insert(index)
            excludedFromBatchEditing.remove(index)
        }
    }
    
    func valueDidChange(at index: Int, value: Double?) {
        if focusedIndex != index {
            return
        }
        for index in sets.indices where batchEditedIndices.contains(index) {
            sets.wrappedValue[index] = value
        }
    }
}
