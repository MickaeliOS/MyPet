//
//  EditVeterinarianViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import Foundation

extension EditVeterinarianView {

    @Observable
    final class ViewModel {
        let sampleVeterinarian = Veterinarian(name: nil, address: nil, phone: nil, website: nil)

        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .address,
                .address: .phone,
                .phone: .website
            ]

            return transitions[focusedField] ?? .name
        }
    }

    enum FocusedField {
        case name
        case address
        case phone
        case website
    }
}
