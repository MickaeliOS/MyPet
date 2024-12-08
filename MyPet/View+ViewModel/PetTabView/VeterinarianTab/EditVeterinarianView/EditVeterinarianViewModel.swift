//
//  EditVeterinarianViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import Foundation
import SwiftData

extension EditVeterinarianView {

    // MARK: - ENUM
    enum FocusedField {
        case name
        case address
        case phone
        case website
    }

    // MARK: - VIEW MODEL
    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        var veterinarian: Veterinarian?
        var errorMessage = ""
        var showingAlert = false
        let sampleVeterinarian = Veterinarian(name: nil, address: nil, phone: nil, website: nil)

        // MARK: FUNCTION
        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .address,
                .address: .phone,
                .phone: .website
            ]

            return transitions[focusedField] ?? .name
        }

        func savePet(pet: Pet, context: ModelContext) -> Bool {
            let veterinarianCopy = pet.veterinarian

            pet.veterinarian = veterinarian

            do {
                try SwiftDataHelper().save(with: context)
                return true
            } catch {
                pet.veterinarian = veterinarianCopy
                errorMessage = error.description
                showingAlert = true
                return false
            }
        }
    }
}
