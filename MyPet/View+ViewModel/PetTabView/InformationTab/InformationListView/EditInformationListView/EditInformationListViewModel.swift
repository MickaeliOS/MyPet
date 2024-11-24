//
//  EditInformationListViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 23/10/2024.
//

import Foundation
import SwiftUI
import PhotosUI
import SwiftData

extension EditInformationListView {

    // MARK: - ENUM
    enum FocusedField {
        case name
        case type
        case race
        case color
        case eyeColor
    }

    // MARK: - VIEW MODEL
    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        var sampleInformation = Information(
            name: "",
            gender: .male,
            type: "",
            race: "",
            birthdate: .now,
            color: "",
            eyeColor: ""
        )

        var information: Information?
        var errorMessage = ""
        var showingAlert = false

        // MARK: FUNCTION
        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .type,
                .type: .race,
                .race: .color,
                .color: .eyeColor
            ]

            return transitions[focusedField] ?? .name
        }

        func savePet(pet: Pet, context: ModelContext, undoManager: UndoManager?) -> Bool {
            let informationCopy = pet.information

            guard let information else { return true }

            pet.information = information

            do {
                try SwiftDataHelper.save(with: context)
                return true
            } catch {
                pet.information = informationCopy
                errorMessage = error.description
                showingAlert = true
                return false
            }
        }
    }
}
