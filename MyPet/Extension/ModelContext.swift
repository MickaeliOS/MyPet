//
//  ModelContext.swift
//  MyPet
//
//  Created by Mickaël Horn on 23/09/2024.
//

import Foundation
import SwiftData

extension ModelContext {
    
    // MARK: PROPERTY
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
