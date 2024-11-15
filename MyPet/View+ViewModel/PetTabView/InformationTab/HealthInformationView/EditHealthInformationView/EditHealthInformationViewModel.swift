//
//  EditHealthInformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 16/09/2024.
//

import Foundation

extension EditHealthInformationView {

    @Observable
    final class ViewModel {
        var allergies: [String] = []
        var intolerances: [String] = []
        var isSterelized = false

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
    }
}
