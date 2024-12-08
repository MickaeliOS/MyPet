//
//  EditInformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 26/08/2024.
//

import Foundation
import SwiftData

extension EditInformationView {

    // MARK: - ENUM
    enum FocusedField {
        case name
        case type
        case race
        case color
        case eyeColor
        case chip
        case chipLocation
        case tatoo
        case tatooLocation
        case toy
        case food
        case place
    }

    // MARK: - VIEW MODEL
    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        let sampleIdentification = Identification(chip: nil, chipLocation: nil, tatoo: nil, tatooLocation: nil)
        let sampleFavorite = Favorite(toy: nil, food: nil, place: nil)

        var identification: Identification?
        var favorite: Favorite?
        var errorMessage = ""
        var showingAlert = false
        var swiftDataHelper: SwiftDataProtocol

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
                .color: .eyeColor,
                .eyeColor: .chip,
                .chip: .chipLocation,
                .chipLocation: .tatoo,
                .tatoo: .tatooLocation,
                .tatooLocation: .toy,
                .toy: .food,
                .food: .place
            ]

            return transitions[focusedField] ?? .name
        }

        func savePet(pet: Pet, context: ModelContext) -> Bool {
            let identificationCopy = pet.identification
            let favoriteCopy = pet.favorite

            pet.identification = identification
            pet.favorite = favorite

            do {
                try swiftDataHelper.save(with: context)
                return true
            } catch {
                pet.identification = identificationCopy
                pet.favorite = favoriteCopy
                errorMessage = error.description
                showingAlert = true
                return false
            }
        }
    }
}
