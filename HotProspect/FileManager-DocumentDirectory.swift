//
//  FileManager-DocumentDirectory.swift
//  HotProspect
//
//  Created by Sergey Shcheglov on 24.02.2022.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
