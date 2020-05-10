//
//  DatabaseModelVersion.swift
//  Services
//
//  Created by Łukasz Kasperek on 07/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import CoreData
import Foundation

enum DatabaseModelVersion: String {
    case version1 = "Weights"
    
    var name: String { rawValue }
    var modelBundle: Bundle { .init(for: Exercise.self) }
    var modelDirectoryName: String { "Weights.momd" }
}

extension DatabaseModelVersion {
    func managedObjectModel() -> NSManagedObjectModel {
        let omoURL = modelBundle.url(
            forResource: name,
            withExtension: "omo",
            subdirectory: modelDirectoryName
        )
        let momURL = modelBundle.url(
            forResource: name,
            withExtension: "mom",
            subdirectory: modelDirectoryName
        )
        guard let url = omoURL ?? momURL else {
            fatalError("model version \(self) not found")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("cannot open model at \(url)")
        }
        return model
    }
}
