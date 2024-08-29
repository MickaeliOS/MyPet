//
//  OptionalExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 29/08/2024.
//

import Foundation

extension Optional where Wrapped == String {
    func defaultValueIfNilOrEmpty(_ defaultValue: String = "Non renseigné") -> String {
        switch self {
        case .some(let value) where !value.isEmpty:
            return value
        default:
            return defaultValue
        }
    }
}
