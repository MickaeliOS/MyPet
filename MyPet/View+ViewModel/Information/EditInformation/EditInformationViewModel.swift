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
    }
}
