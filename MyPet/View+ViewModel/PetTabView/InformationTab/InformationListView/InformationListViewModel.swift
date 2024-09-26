//
//  InformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 27/08/2024.
//

import Foundation

extension InformationListView {

    @Observable
    final class ViewModel {
//        func orDefault(_ value: String?) -> String {
//            return value.orDefault()
//        }

        func getGender(gender: Pet.Gender) -> String {
            return gender == .male ? "male" :
                   gender == .female ? "female" :
                   "hermaphrodite"
        }
    }
}
