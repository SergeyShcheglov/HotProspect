//
//  Prospect.swift
//  HotProspect
//
//  Created by Sergey Shcheglov on 22.02.2022.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
    let savePaths = FileManager.documentDirectory.appendingPathComponent("Saved contacts")
    
    init() {
        if let savedData = try? Data(contentsOf: savePaths) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: savedData) {
                people = decoded
                return
            }
        }
        
        //no saved data
        people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: savePaths, options: [.atomic, .completeFileProtection])
        }
        
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
