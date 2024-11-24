//
//  ArrayExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 14/11/2024.
//

import Foundation

extension Array where Element == String {

    // MARK: FUNCTION
    func removeEmptyElement() -> Array {
        self.filter { !$0.isEmpty }
    }
}
