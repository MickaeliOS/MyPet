//
//  Previewer.swift
//  MyPet
//
//  Created by Mickaël Horn on 08/08/2024.
//

import Foundation
import SwiftData

@MainActor
final class Previewer {
    let container: ModelContainer
    let firstPet: Pet
    let secondPet: Pet

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Pet.self, configurations: config)

        // Pet1
        let firstPetInfo = Information(
            name: "MrCat",
            gender: .male,
            type: "Cat",
            race: "Scottish fold",
            birthdate: Date.now,
            color: "Brown",
            eyeColor: "Black",
            photo: nil
        )

        // Pet2
        let secondPetInfo = Information(
            name: "MrsDog",
            gender: .female,
            type: "Dog",
            race: "Labrador",
            birthdate: Date.now,
            color: "Brown",
            eyeColor: "Black",
            photo: nil
        )

        firstPet = Pet(information: firstPetInfo)
        secondPet = Pet(information: secondPetInfo)

        container.mainContext.insert(firstPet)
        container.mainContext.insert(secondPet)
    }
}
