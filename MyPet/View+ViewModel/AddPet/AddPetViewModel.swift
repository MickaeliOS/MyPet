//
//  AddPetViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 06/08/2024.
//

import Foundation

extension AddPetView {

    @Observable
    final class ViewModel {
        var name = ""
        var gender = Pet.Gender.other
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
