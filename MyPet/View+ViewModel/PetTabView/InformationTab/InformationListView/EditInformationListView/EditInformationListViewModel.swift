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
        var information: Information?
        var errorMessage = ""
        var showingAlert = false
        var swiftDataHelper: SwiftDataProtocol

        var sampleInformation = Information(
            name: "",
            gender: .male,
            type: "",
            race: "",
            birthdate: .now,
            color: "",
            eyeColor: ""
        )

        var isFormValid: Bool {
            guard let info = information else { return false }
            return String.areStringsNotEmpty(strings: info.name, info.race, info.type, info.eyeColor, info.color)
        }

        // MARK: INIT
        init(swiftDataHelper: SwiftDataProtocol = SwiftDataHelper()) {
            self.swiftDataHelper = swiftDataHelper
        }

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

        func savePet(pet: Pet, context: ModelContext) -> Bool {
            guard let information else { return true }

            let informationCopy = pet.information

            pet.information = information

            do {
                try swiftDataHelper.save(with: context)
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
