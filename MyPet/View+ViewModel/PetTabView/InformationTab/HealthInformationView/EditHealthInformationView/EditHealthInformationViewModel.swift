//
//  EditHealthInformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 16/09/2024.
//

import Foundation

extension EditHealthInformationView {

    @Observable
    final class ViewModel {
        func isListValid(_ list: [String]) -> Bool {
            return !list.isEmpty && list.allSatisfy { !$0.isEmpty }
        }
    }
}
