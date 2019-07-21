//
//  RootTabbedView.swift
//  Weights
//
//  Created by Łukasz Kasperek on 15/06/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct RootTabbedView : View {
    var body: some View {
        TabbedView(selection: .constant(3)) {
            Text("Tab 1!")
                .tabItem({
                    Text("Plan")
                })
                .tag(1)
            Text("Tab 2!")
                .tabItem({
                    Text("Tab 2")
                })
                .tag(2)
            ExercisesView(model: .sample)
                .tag(3)
                .tabItem({
                    Text("Exercises")
                })
        }
    }
}

#if DEBUG
struct RootTabbedView_Previews : PreviewProvider {
    static var previews: some View {
        RootTabbedView()
    }
}
#endif
