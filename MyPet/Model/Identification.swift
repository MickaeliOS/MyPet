//
//  Identification.swift
//  MyPet
//
//  Created by Mickaël Horn on 06/08/2024.
//

import Foundation
import SwiftData

@Model
final class Identification {
    let chip: Int?
    let chipLocation: String?
    let tatoo: String?
    let tatooLocation: String?

    init(chip: Int?, chipLocation: String?, tatoo: String?, tatooLocation: String?) {
        self.chip = chip
        self.chipLocation = chipLocation
        self.tatoo = tatoo
        self.tatooLocation = tatooLocation
    }
}
