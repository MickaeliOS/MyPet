//
//  ChartViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import Foundation
import SwiftData

extension ChartView {

    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        var weight: Double?
        var day = Date.now
        var errorMessage = ""
        var showingAlert = false

        var isFormValid: Bool {
            return weight != nil
        }

        // MARK: FUNCTION
        func addWeight(for pet: Pet, context: ModelContext) {
            guard let weight = weight else {
                return
            }

            if pet.weights == nil {
                pet.weights = []
            }

            let weightsCopy = pet.weights

            let newWeight = Weight(day: day, weight: weight)
            pet.addWeight(weight: newWeight)
            self.weight = nil

            savePet(pet: pet, weightsCopy: weightsCopy, context: context)
        }

        // MARK: PRIVATE FUNCTION
        private func savePet(pet: Pet, weightsCopy: [Weight]?, context: ModelContext) {
            do {
                try SwiftDataHelper.save(with: context)
            } catch {
                pet.weights = weightsCopy
                errorMessage = error.description
                showingAlert = true
            }
        }
    }
}
