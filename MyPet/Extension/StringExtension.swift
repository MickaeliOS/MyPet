//
//  StringExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 06/08/2024.
//

import Foundation

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
