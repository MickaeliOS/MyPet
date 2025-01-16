//
//  StringExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 06/08/2024.
//

import Foundation

extension String {
    
    // MARK: PROPERTY
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: FUNCTION
    static func areStringsNotEmpty(strings: String...) -> Bool {
        return !strings.contains { $0.isReallyEmpty }
    }
}
