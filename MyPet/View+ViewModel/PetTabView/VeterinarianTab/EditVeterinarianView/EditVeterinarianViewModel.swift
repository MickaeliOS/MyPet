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
        var name = ""
        var address = ""
        var phone: Int?
        var website = ""

        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .address,
                .address: .phone,
                .phone: .website
            ]

            return transitions[focusedField] ?? .name
        }

        var isFormValid: Bool {
            name.isReallyEmpty || address.isReallyEmpty
        }
    }

    // MARK: ENUM
    enum FocusedField {
        case name
        case address
        case phone
        case website
    }
}
