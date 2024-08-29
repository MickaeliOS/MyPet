//
//  EditInformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 26/08/2024.
//

import Foundation

extension EditInformationView {

    @Observable
    final class ViewModel {
        let sampleIdentification = Identification(chip: nil, chipLocation: nil, tatoo: nil, tatooLocation: nil)
        let sampleFavorite = Favorite(toy: nil, food: nil, place: nil)

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
                .food: .place,
                .place: .name
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
        case chip
        case chipLocation
        case tatoo
        case tatooLocation
        case toy
        case food
        case place
    }
}
