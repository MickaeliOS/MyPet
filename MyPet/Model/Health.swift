//
//  Health.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import Foundation

struct Health: Codable {

    // MARK: PROPERTY
    var isSterelized: Bool?
    var intolerances: [String]?
    var allergies: [String]?

    // MARK: INIT
    init(
        isSterelized: Bool? = nil,
        intolerances: [String]? = nil,
        allergies: [String]? = nil

    ) {
        self.isSterelized = isSterelized
        self.intolerances = intolerances
        self.allergies = allergies
    }
}
