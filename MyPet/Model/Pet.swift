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
    let name: String
    let gender: Gender
    let type: String
    let race: String
    let birthdate: Date
    let color: String
    let eyeColor: String
    var photo: Data?
    let identification: Identification?

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
        case other = "Autre"
    }
}
