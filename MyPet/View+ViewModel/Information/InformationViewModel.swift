//
//  InformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 27/08/2024.
//

import Foundation

extension InformationView {

    @Observable
    final class ViewModel {
        func defaultValueIfNilOrEmpty(_ value: String?) -> String {
            return value.defaultValueIfNilOrEmpty()
        }

        func getGender(gender: Pet.Gender) -> String {
            return gender == .male ? Pet.Gender.male.rawValue :
                   gender == .female ? Pet.Gender.female.rawValue :
                   Pet.Gender.hermaphrodite.rawValue
        }
    }
}
