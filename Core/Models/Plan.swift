//
//  Plan.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

public struct Plan: Equatable {
    public let name: String
    public let days: [PlannedDay]
    
    public init(name: String, days: [PlannedDay]) {
        self.name = name
        self.days = days
    }
}

#if DEBUG
extension Plan {
    enum Proto {
        struct Day {
            let exercisesPrototypes: [Proto.Exercise]
            
            init(_ exercises: Proto.Exercise...) {
                self.exercisesPrototypes = exercises
            }
        }
        
        struct Exercise {
            let setCollectionPrototypes: [Collection]
            
            init(_ setCollections: Collection...) {
                self.setCollectionPrototypes = setCollections
            }
        }
        
        struct Collection {
            let sets: Int
            let reps: Int
            let weight: Double
            
            init(_ sets: Int, _ reps: Int, _ weight: Double) {
                self.sets = sets
                self.reps = reps
                self.weight = weight
            }
        }
    }
    
    static func make(_ daysProtos: Proto.Day...) -> Plan {
        var days = [PlannedDay]()
        for (dayIndex, dayProto) in daysProtos.enumerated() {
            var exercises = [PlannedExercise]()
            for exerciseProto in dayProto.exercisesPrototypes {
                let setCollection = exerciseProto.setCollectionPrototypes
                    .map { collection in
                        PlannedExercise.SetCollection(
                            numberOfSets: collection.sets,
                            volume: collection.reps,
                            weight: Weight(value: collection.weight, unit: .kg)
                        )
                    }
                let exercise = PlannedExercise(
                    exercise: .make(),
                    pace: nil,
                    setCollections: setCollection,
                    createsSupersets: false
                )
                exercises.append(exercise)
            }
            let day = PlannedDay(name: "A\(dayIndex + 1)", exercises: exercises)
            days.append(day)
        }
        return Plan(name: "Upper-Lower", days: days)
    }
}
#endif
