//
//  PetInformationFormViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 23/08/2024.
//

import Foundation

extension PetInformationForm {

    @Observable
    final class ViewModel {
        var name = ""
        var gender = Pet.Gender.male
        var race = ""
        var type = ""
        var birthdate = Date.now
        var eyeColor = ""
        var color = ""
        var photo: Data?

        var isFormValid: Bool {
            (
                name.isReallyEmpty ||
                race.isReallyEmpty ||
                type.isReallyEmpty ||
                eyeColor.isReallyEmpty ||
                color.isReallyEmpty
            )
        }
    }
}
