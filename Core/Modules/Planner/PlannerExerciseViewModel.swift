//
//  PlannerExerciseViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 07/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

class PlannerExerciseViewModel: PlannerExerciseViewModeling {
    var name: String { exercise.name }
    @Published var variations: [PlannerSetCellModel] = [] {
        didSet {
            performPostVariationsModificationCheck()
        }
    }
    
    private let exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
        prepareInitialVariationsState()
    }
    
    private func prepareInitialVariationsState() {
        variations = [baseVariation()]
    }
    
    private func baseVariation() -> PlannerSetCellModel {
        PlannerSetCellModel(
            metric: exercise.metric,
            numerOfSets: 1,
            metricValue: nil,
            weight: nil
        )
    }
    
    private func performPostVariationsModificationCheck() {
        if let index = variations.lastIndex(where: { $0.numerOfSets == 0 }) {
            variations.remove(at: index)
        }
    }
    
    func addVariationTapped() {
        variations.append(baseVariation())
    }
    
    func makeItemProvider() -> NSItemProvider {
        let archive = PlannerExerciseViewModelArchive(
            exercise: exercise,
            cells: variations
        )
        return NSItemProvider(object: archive)
    }
}

class PlannerExerciseViewModelArchive: NSObject, NSItemProviderWriting, NSItemProviderReading {
    static var writableTypeIdentifiersForItemProvider: [String] {
        [PlannerExerciseDraggable.uti.identifier]
    }
    static var readableTypeIdentifiersForItemProvider: [String] {
        [PlannerExerciseDraggable.uti.identifier]
    }
    
    struct DataContainer: Codable {
        let exercise: Exercise
        let cells: [PlannerSetCellModel]
    }
    
    private let dataContainer: DataContainer
    
    init(exercise: Exercise, cells: [PlannerSetCellModel]) {
        self.dataContainer = DataContainer(exercise: exercise, cells: cells)
        super.init()
    }
    
    required init(dataContainer: DataContainer) {
        self.dataContainer = dataContainer
        super.init()
    }
    
    func loadData(
        withTypeIdentifier typeIdentifier: String,
        forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void
    ) -> Progress? {
        completionHandler(encode(), nil)
        return nil
    }
    
    private func encode() -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(dataContainer)
    }
    
    static func object(
        withItemProviderData data: Data,
        typeIdentifier: String
    ) throws -> Self {
        let decoder = JSONDecoder()
        let dataContainer = try decoder.decode(DataContainer.self, from: data)
        return Self(dataContainer: dataContainer)
    }
}
