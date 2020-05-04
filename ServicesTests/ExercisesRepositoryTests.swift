//
//  ExercisesRepositoryTests.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
@testable import Services
import XCTest

class ExercisesRepositoryTests: XCTestCase {
    var sut: ExercisesRepository!

    override func setUpWithError() throws {
        let container = try awaitValue(makeInMemoryPeristentContainer())
        let database = Database(persistentContainer: container)
        sut = database.getExercisesRepository()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testAdd() {
        XCTAssert(true)
    }
}
