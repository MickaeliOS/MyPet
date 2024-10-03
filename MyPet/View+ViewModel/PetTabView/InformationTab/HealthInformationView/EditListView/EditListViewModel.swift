//
//  EditListViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import Foundation

extension EditListView {

    @Observable
    final class ViewModel {
        var dataType: DataType

        init(dataType: DataType) {
            self.dataType = dataType
        }
    }

    enum DataType: String {
        case allergy = "Allergies"
        case intolerance = "Intolérances"

        var imageName: String {
            switch self {
            case .allergy:
                "allergens.fill"
            case .intolerance:
                "exclamationmark.octagon.fill"
            }
        }
    }
}
