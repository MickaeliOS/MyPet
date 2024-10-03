//
//  Weight.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import Foundation

struct Weight: Codable, Identifiable {
    var id = UUID()
    let day: Date
    let weight: Double
}
