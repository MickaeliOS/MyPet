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

    enum AddPetViewModelError: Error {
        case invalidFields

        var description: String {
            switch self {
            case .invalidFields:
                "Veuillez vérifier que tous les champs sont correctement remplis."
            }
        }
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
        var errorMessage = ""
        var showingAlert = false

        // MARK: FUNCTIONS
        var isFormValid: Bool {
            String.areStringsValid(strings: name, race, type, eyeColor, color)
        }

        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .type,
                .type: .race,
                .race: .color,
                .color: .eyeColor
            ]

            return transitions[focusedField] ?? .name
        }

        func addPet(modelContext: ModelContext) -> Bool {
            guard isFormValid else {
                errorMessage = AddPetViewModelError.invalidFields.description
                showingAlert = true
                return false
            }

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

            do {
                try SwiftDataHelper.save(with: modelContext)
                return true
            } catch {
                modelContext.rollback()
                errorMessage = error.description
                showingAlert = true
                return false
            }
        }
    }
}
