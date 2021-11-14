//
//  RootViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

class RootViewModel: RootViewModeling {
    let routes: RootRoutes<ExercisesListViewModel>
    
    init(routes: RootRoutes<ExercisesListViewModel>) {
        self.routes = routes
    }
}
