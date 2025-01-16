//
//  Information.swift
//  MyPet
//
//  Created by Mickaël Horn on 16/09/2024.
//

import Foundation

struct Information: Codable {

    // MARK: PROPERTY
    var name: String
    var gender: Gender
    var type: String
    var race: String
    var birthdate: Date
    var color: String
    var eyeColor: String
    var photo: Data?
}

// MARK: - EXTENSION
extension Information {
    enum Gender: String, Codable, CaseIterable {
        case male = "Mâle"
        case female = "Femelle"
        case hermaphrodite = "Hermaphrodite"

        var getGenderImage: String {
            switch self {
            case .male:
                "male"
            case .female:
                "female"
            case .hermaphrodite:
                "hermaphrodite"
            }
        }
    }

    var getStringAge: String {
        let calendar = Calendar.current
        let now = Date()

        let components = calendar.dateComponents([.year, .month, .day], from: birthdate, to: now)

        if let years = components.year, years > 0 {
            return "\(years) an" + (years > 1 ? "s" : "")
        } else if let months = components.month, months > 0 {
            return "\(months) mois"
        } else if let days = components.day, days > 0 {
            return "\(days) jour" + (days > 1 ? "s" : "")
        } else {
            return "Aujourd'hui"
        }
    }
}
