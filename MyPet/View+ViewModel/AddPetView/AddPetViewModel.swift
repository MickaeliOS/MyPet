//
//  AddPetViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 06/08/2024.
//

import Foundation
import SwiftData

extension AddPetView {

    // MARK: - ENUM
    enum FocusedField {
        case name
        case type
        case race
        case color
        case eyeColor
    }

    // MARK: - VIEWMODEL
    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        var name = ""
        var gender = Information.Gender.male
        var race = ""
        var type = ""
        var birthdate = Date.now
        var eyeColor = ""
        var color = ""
        var photo: Data?

        // MARK: FUNCTIONS
        var isFormValid: Bool {
            (
                name.isReallyEmpty ||
                race.isReallyEmpty ||
                type.isReallyEmpty ||
                eyeColor.isReallyEmpty ||
                color.isReallyEmpty
            )
        }

        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .type,
                .type: .race,
                .race: .color,
                .color: .eyeColor,
                .eyeColor: .eyeColor
            ]

            return transitions[focusedField] ?? .name
        }

        func addPet(modelContext: ModelContext) {
            let information = Information(
                name: name,
                gender: gender,
                type: type,
                race: race,
                birthdate: birthdate,
                color: color,
                eyeColor: eyeColor,
                photo: photo
            )

            modelContext.insert(Pet(information: information))
        }
    }
}
