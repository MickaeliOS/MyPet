//
//  PetTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 08/12/2024.
//

import Foundation
@testable import MyPet

struct PetTest {
    let pet = Pet(information: Information(
        name: "testName",
        gender: .male,
        type: "testType",
        race: "testRace",
        birthdate: Date.now,
        color: "testColor",
        eyeColor: "testEyeColor"
    ))
}
