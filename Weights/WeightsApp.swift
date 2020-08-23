//
//  WeightsApp.swift
//  Weights
//
//  Created by Łukasz Kasperek on 05/07/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI
import Core

@main
struct WeightsApp: App {
    let dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            CoreEntry(dependencies: dependencies).makeInitialView()
        }
    }
}
