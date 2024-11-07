//
//  EditInformationListViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 23/10/2024.
//

import Foundation
import SwiftUI
import PhotosUI

extension EditInformationListView {

    @Observable
    final class ViewModel {
        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .type,
                .type: .race,
                .race: .color,
                .color: .eyeColor,
                .eyeColor: .eyeColor
            ]

            return transitions[focusedField] ?? .name
        }
    }

    enum FocusedField {
        case name
        case type
        case race
        case color
        case eyeColor
    }
}
