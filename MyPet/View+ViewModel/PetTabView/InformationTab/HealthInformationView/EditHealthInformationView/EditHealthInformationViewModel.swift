//
//  EditHealthInformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 16/09/2024.
//

import Foundation
import SwiftData

extension EditHealthInformationView {

    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        var allergies: [String] = []
        var intolerances: [String] = []
        var isSterelized = false
        var isSterelizedChanged = false
        var errorMessage = ""
        var showingAlert = false

        // MARK: FUNCTION
        func removeEmptyElement() {
            if !allergies.isEmpty {
                allergies = allergies.removeEmptyElement()
            }

            if !intolerances.isEmpty {
                intolerances = intolerances.removeEmptyElement()
            }
        }

        func setupHealthInformations(with health: Health?) {
            if let health {
                allergies = health.allergies ?? []
                intolerances = health.intolerances ?? []

                if let isSterelized = health.isSterelized {
                    self.isSterelized = isSterelized
                }
            }
        }

        func savePet(pet: Pet, context: ModelContext, undoManager: UndoManager?) -> Bool {
            let healthCopy = pet.health

            if pet.health == nil {
                pet.health = Health()
            }

            if !allergies.isEmpty {
                allergies = allergies.removeEmptyElement()
                pet.health?.allergies = allergies
            } else {
                pet.health?.allergies = nil
            }

            if !intolerances.isEmpty {
                intolerances = intolerances.removeEmptyElement()
                pet.health?.intolerances = intolerances
            } else {
                pet.health?.intolerances = nil
            }

            if isSterelizedChanged { pet.health?.isSterelized = isSterelized }

            do {
                try SwiftDataHelper.save(with: context)
                return true
            } catch {
                pet.health = healthCopy
                errorMessage = error.description
                showingAlert = true
                return false
            }
        }
    }
}
