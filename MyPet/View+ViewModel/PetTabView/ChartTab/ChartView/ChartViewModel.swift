//
//  ChartViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import Foundation

extension ChartView {

    @Observable
    final class ViewModel {
        var weight: Double?
        var day = Date.now

        var isFormValid: Bool {
            return weight != nil
        }
    }
}
