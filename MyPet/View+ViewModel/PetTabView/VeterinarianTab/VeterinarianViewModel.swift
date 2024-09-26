//
//  VeterinarianViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 02/09/2024.
//

import Foundation

extension VeterinarianView {

    @Observable
    final class ViewModel {
        func orDefault(_ value: String?) -> String {
            return value.orDefault()
        }
    }
}
