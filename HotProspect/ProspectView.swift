//
//  ProspectView.swift
//  HotProspect
//
//  Created by Sergey Shcheglov on 22.02.2022.
//

import SwiftUI

struct ProspectView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    @EnvironmentObject var prospects: Prospects
    var body: some View {
        NavigationView {
            Text("People: \(prospects.people.count)")
                .navigationTitle(title)
                .toolbar {
                    Button {
                        let prospect = Prospect()
                        prospect.name = "Sergey Shcheglov"
                        prospect.emailAddress = "97shcheglov@gmail.com"
                        prospects.people.append(prospect)
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectView(filter: .none)
            .environmentObject(Prospects())
    }
}
