//
//  Information.swift
//  MyPet
//
//  Created by Mickaël Horn on 16/09/2024.
//

import Foundation

struct Information: Codable {
    var name: String
    var gender: Gender
    var type: String
    var race: String
    var birthdate: Date
    var color: String
    var eyeColor: String
    var photo: Data?
}

extension Information {
    enum Gender: String, Codable, CaseIterable {
        case male = "Mâle"
        case female = "Femelle"
        case hermaphrodite = "Hermaphrodite"
    }

    var getStringAge: String {
        let calendar = Calendar.current
        let currentDate = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: currentDate)

        if let age = ageComponents.year {
            return String(age)
        } else {
            return "Âge inconnu"
        }
    }
}
