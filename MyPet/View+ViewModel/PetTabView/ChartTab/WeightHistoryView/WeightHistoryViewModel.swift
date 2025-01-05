//
//  WeightHistoryViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 27/11/2024.
//

import Foundation
import SwiftData

extension WeightHistoryView {

    @Observable
    final class ViewModel {
        var errorMessage = ""
        var showingAlert = false
        var swiftDataHelper: SwiftDataProtocol

        // MARK: INIT
        init(swiftDataHelper: SwiftDataProtocol = SwiftDataHelper()) {
            self.swiftDataHelper = swiftDataHelper
        }

        func deleteWeight(pet: Pet, offsets: IndexSet, context: ModelContext) {
            let weightCopy = pet.weights

            pet.deleteWeight(offsets: offsets)

            do {
                try swiftDataHelper.save(with: context)
            } catch {
                pet.weights = weightCopy
                errorMessage = error.description
                showingAlert = true
            }
        }
    }
}
