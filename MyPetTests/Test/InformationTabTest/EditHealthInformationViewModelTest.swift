//
//  EditHealthInformationViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 08/12/2024.
//

import Foundation
import Testing
import SwiftData
@testable import MyPet

final class EditHealthInformationViewModelTest {
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private let sut: EditHealthInformationView.ViewModel!

    init() {
        mockSwiftDataHelper = .init()
        sut = .init(swiftDataHelper: mockSwiftDataHelper)
    }

    @Test("With Health informations from Health object, sut's health informations should be set")
    func sutHealthInfosShouldBeSetup() {
        let health = Health(isSterelized: true, intolerances: ["gluten"], allergies: ["beef"])
        sut.setupHealthInformations(with: health)

        #expect(sut.allergies.count == 1)
        #expect(sut.allergies == ["beef"])
        #expect(sut.intolerances.count == 1)
        #expect(sut.intolerances == ["gluten"])
    }

    @Test("From Health object without allergy/intolerance array, empty arrays should be setup")
    func sutHealthInfosShouldBeSetupWithEmptyArrays() {
        let health = Health(isSterelized: true)
        sut.setupHealthInformations(with: health)

        #expect(sut.allergies.isEmpty)
        #expect(sut.allergies.isEmpty)
        #expect(sut.isSterelized == true)
    }

    @Test("With nil Health object, sut's health informations should be default")
    func sutHealthInfosShouldBeDefautltIfNilHealth() {
        sut.setupHealthInformations(with: nil)
        #expect(sut.allergies.isEmpty)
        #expect(sut.intolerances.isEmpty)
        #expect(sut.isSterelized == false)
    }

    @MainActor
    @Test(
        """
            Without any Health infos yet, Pet's health infos should be saved 
            with new infos (allergy and intolerance array + isSterelized
        """
    )
    func petHealthInfosShouldBeSaved() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer

        #expect(throws: Never.self) {
            // When saving the pet, he must exist in the database already,
            // so we're creating it, otherwise, modification will not be saved
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)
            #expect(pets.count == 1)
            let testingPet = pets[0]

            sut.allergies = ["beef", ""]
            sut.intolerances = ["gluten", "", "lactose"]
            sut.isSterelizedChanged = true
            sut.isSterelized = true

            #expect(self.sut.savePet(pet: testingPet, context: mockContainer.mainContext))

            // Now, let's make sure the changes propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let savedPets = try newContext.fetch(secondDescriptor)

            #expect(savedPets.count == 1)
            #expect(savedPets[0].health?.allergies == ["beef"])
            #expect(savedPets[0].health?.intolerances == ["gluten", "lactose"])
            #expect(savedPets[0].health?.isSterelized ?? false)
        }
    }

    @MainActor
    @Test("Without Health object, no allergies/intolerances and isSterelized to true, health infos are saved")
    func withoutAllergyAndIntolerancePetHealthInfosShouldBeSaved() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer

        #expect(throws: Never.self) {
            // When saving the pet, he must exist in the database already,
            // so we're creating it, otherwise, modification will not be saved
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)

            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)
            #expect(pets.count == 1)
            let testingPet = pets[0]

            sut.isSterelizedChanged = true
            sut.isSterelized = true

            #expect(self.sut.savePet(pet: testingPet, context: mockContainer.mainContext))

            // Now, let's make sure the changes propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let savedPets = try newContext.fetch(secondDescriptor)

            #expect(savedPets.count == 1)
            #expect(savedPets[0].health?.allergies == nil)
            #expect(savedPets[0].health?.intolerances == nil)
            #expect(savedPets[0].health?.isSterelized ?? false)
        }
    }

    @MainActor
    @Test("If saving the pet crashes, we should roll back health infos")
    func healthInfosShouldBeRolledBackIfSaveCrashes() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer

        #expect(throws: Never.self) {
            // When saving the pet, he must exist in the database already,
            // so we're creating it, otherwise, modification will not be saved
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)

            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)
            #expect(pets.count == 1)
            let testingPet = pets[0]

            sut.allergies = ["beef", ""]
            sut.intolerances = ["gluten", "", "lactose"]
            sut.isSterelizedChanged = true
            sut.isSterelized = true

            mockSwiftDataHelper.saveShouldFail = true
            #expect(self.sut.savePet(pet: testingPet, context: mockContainer.mainContext) == false)

            // Let's see if we rolled back correctly
            #expect(pet.health?.allergies == nil)
            #expect(pet.health?.intolerances == nil)
            #expect(pet.health?.isSterelized == nil)

            // Now, let's make sure the changes didn't propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let notSavedPets = try newContext.fetch(secondDescriptor)
            #expect(notSavedPets.count == 1)

            #expect(notSavedPets[0].health?.allergies == nil)
            #expect(notSavedPets[0].health?.intolerances == nil)
            #expect(notSavedPets[0].health?.isSterelized == nil)
        }
    }
}

// test quand health est à nil
