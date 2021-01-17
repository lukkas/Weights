//
//  PlannerView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Kutas")
                }
                
                TabView {
                    ScrollView {
                        ForEach(0 ..< 10) { _ in
                            Button(action: {}, label: {
                                Text(verbatim: L10n.Planner.addDay)
                                    .foregroundColor(.contrastLabel)
                            })
                            .padding(.vertical, 12)
                            .frame(maxWidth: 800)
                            .background(Color.red.cornerRadius(8))
                            .padding()
                            .onDrag({
                                NSItemProvider(object: URL(string: "http://apple.com")! as NSURL)
                            })
                        }
                    }
                    
                    Button(action: {}, label: {
                        Text(verbatim: L10n.Planner.addDay)
                    })
                    .padding(.vertical, 12)
                    .frame(maxWidth: 800)
                    .background(Color.theme.cornerRadius(8))
                    .padding()
                }
                .tabViewStyle(PageTabViewStyle())
                .background(Color(.tertiarySystemBackground))
            }
            .navigationBarTitle(L10n.Planner.title)
        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    fileprivate class PreviewModel: PlannerViewModeling {
        
    }
    
    static var previews: some View {
        PlannerView()
    }
}
