//
//  Favorite.swift
//  MyPet
//
//  Created by Mickaël Horn on 22/08/2024.
//

import Foundation
import SwiftData

@Model
final class Favorite {
    var toy: String
    var food: String
    var place: String

    init(toy: String, food: String, place: String) {
        self.toy = toy
        self.food = food
        self.place = place
    }
}
