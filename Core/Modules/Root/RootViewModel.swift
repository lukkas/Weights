//
//  RootViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

class RootViewModel: ObservableObject {
    struct Routes {
        let exercisesList: () -> ExercisesListViewModel
    }
    
    struct Tab: Identifiable {
        let id = UUID()
        let title: String
    }
    
    @Published var tabs: [Tab]
    let routes: Routes
    
    init(routes: Routes) {
        self.routes = routes
        tabs = Self.buildTabs()
    }
}

private extension RootViewModel {
    static func buildTabs() -> [Tab] {
        return []
    }
}
