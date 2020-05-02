//
//  RootViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

class RootViewModel: ObservableObject {
    struct Tab: Identifiable {
        let id = UUID()
        let title: String
    }
    
    @Published var tabs: [Tab]
    
    init() {
        tabs = Self.buildTabs()
    }
}

private extension RootViewModel {
    static func buildTabs() -> [Tab] {
        return []
    }
}
