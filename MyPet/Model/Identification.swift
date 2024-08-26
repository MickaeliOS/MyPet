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
    var chip: Int?
    var chipLocation: String?
    var tatoo: String?
    var tatooLocation: String?

    init(chip: Int?, chipLocation: String?, tatoo: String?, tatooLocation: String?) {
        self.chip = chip
        self.chipLocation = chipLocation
        self.tatoo = tatoo
        self.tatooLocation = tatooLocation
    }
}
