//
//  AddPetViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 06/08/2024.
//

import Foundation

extension AddPetView {

    @Observable
    final class ViewModel {
        var name = ""
        var gender = Pet.Gender.male
        var race = ""
        var type = ""
        var birthdate = Date.now
        var eyeColor = ""
        var color = ""
        var photo: Data?

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
    }

    enum FocusedField {
        case name
        case type
        case race
        case color
        case eyeColor
    }
}
