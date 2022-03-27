//
//  PlannerExerciseViewModelArchive.swift
//  Core
//
//  Created by Łukasz Kasperek on 27/03/2022.
//

import Foundation

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
    
    let dataContainer: DataContainer
    
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
