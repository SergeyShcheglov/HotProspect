//
//  ContentView.swift
//  HotProspect
//
//  Created by Sergey Shcheglov on 21.02.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTap = "One"
    
    var body: some View {
        TabView(selection: $selectedTap) {
            Text("Tab 1")
                .onTapGesture {
                    selectedTap = "Two"
                }
                .tabItem {
                    Label("One", systemImage: "star")
                }
            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }
                .tag("Two")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
