//
//  Pet.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/08/2024.
//

import Foundation
import SwiftData

@Model
final class Pet {
    var name: String
    var gender: Gender
    var type: String
    var race: String
    var birthdate: Date
    var color: String
    var eyeColor: String
    var photo: Data?
    var identification: Identification?
    var favorite: Favorite?

    init(
        name: String,
        gender: Gender,
        type: String,
        race: String,
        birthdate: Date,
        color: String,
        eyeColor: String,
        photo: Data?
    ) {
        self.name = name
        self.gender = gender
        self.type = type
        self.race = race
        self.birthdate = birthdate
        self.color = color
        self.eyeColor = eyeColor
        self.photo = photo
    }
}

extension Pet {
    enum Gender: String, Codable, CaseIterable {
        case male = "Mâle"
        case female = "Femelle"
        case hermaphrodite = "Hermaphrodite"
    }
}

extension Pet {
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
