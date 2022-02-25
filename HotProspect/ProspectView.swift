//
//  ProspectView.swift
//  HotProspect
//
//  Created by Sergey Shcheglov on 22.02.2022.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingSort = false
    
    @State private var byName = false
    @State private var byLastAdded = false
    
    var isShowingBadge = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(someSorted) { prospect in
                    HStack {
                        if isShowingBadge {
                            if prospect.isContacted {
                                Image(systemName: "person.fill.checkmark")
                                
                            } else {
                                Image(systemName: "person.fill.xmark")
                            } }
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button {
                            byName = true
                            byLastAdded = false
                        } label: {
                                Label("by Name", systemImage: (byName ? "checkmark" : ""))
                        }
                        
                        Button {
                            byName = false
                            byLastAdded = true
                        } label: {
                            Label("by lastAdded", systemImage: (byLastAdded ? "checkmark" : ""))
                        }
                        
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                            .labelStyle(.titleAndIcon)
                    }
                    
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Sergey Shcheglov\n97shcheglov@gmail.com", completion: handleScan)
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
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people;
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var someSorted: [Prospect] {
        if byName {
            return filteredProspects.sorted { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending}
        }
        
        if byLastAdded {
            return filteredProspects.sorted { $1.dateAdded < $0.dateAdded }
        }
        
        return filteredProspects
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
//            person.dateAdded = Date.now
            prospects.add(person)
        case .failure(let error):
            print("Scanning error: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { setting in
            if setting.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh!")
                    }
                }
            }
        }
        
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectView(filter: .none)
            .environmentObject(Prospects())
    }
}
