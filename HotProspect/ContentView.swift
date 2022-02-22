//
//  ContentView.swift
//  HotProspect
//
//  Created by Sergey Shcheglov on 21.02.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        VStack {
        Text("Hello, world")
            .padding()
            .background(backgroundColor)
        
            Text("Change color")
                .padding()
                .contextMenu {
                    Button(role: .destructive) {
                        backgroundColor = .red
                    } label: {
                        Label("Red", systemImage: "checkmark.circle.fill")
                    }
                    Button("Blue") {
                        backgroundColor = .blue
                    }
                    
                    Button("Green") {
                        backgroundColor = .green
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
