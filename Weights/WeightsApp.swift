//
//  WeightsApp.swift
//  Weights
//
//  Created by Łukasz Kasperek on 05/07/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI
import Core

@main struct WeightsLauncher {
    static func main() throws {
        #if DEBUG
        if NSClassFromString("XCTestCase") == nil {
            WeightsApp.main()
        } else {
            TestAppDummy.main()
        }
        #else
        WeightsApp.main()
        #endif
    }
}

struct WeightsApp: App {
    let dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            CoreEntry(dependencies: dependencies).makeInitialView()
        }
    }
}

#if DEBUG
struct TestAppDummy: App {
    var body: some Scene {
        WindowGroup {
            Text("Testing...")
        }
    }
}
#endif
