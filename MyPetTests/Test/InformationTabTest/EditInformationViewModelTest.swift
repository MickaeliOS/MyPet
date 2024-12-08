//
//  EditInformationViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 05/12/2024.
//

import Foundation
import Testing
import SwiftData
@testable import MyPet

final class EditInformationViewModelTest {
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private let sut: EditInformationView.ViewModel!

    init() {
        mockSwiftDataHelper = .init()
        sut = .init(swiftDataHelper: mockSwiftDataHelper)
    }

    @Test("When FocusedField is .name, nextField() should return .type FocusedField.")
    func nextFieldFunctionShouldReturnWithType() {
        let focusedField = EditInformationView.FocusedField.name

        #expect(sut.nextField(focusedField: focusedField) == .type)
    }

    @Test("When FocusedField is .type, nextField() should return .race FocusedField.")
    func nextFieldFunctionShouldReturnWithRace() {
        let focusedField = EditInformationView.FocusedField.type

        #expect(sut.nextField(focusedField: focusedField) == .race)
    }

    @Test("When FocusedField is .race, nextField() should return .color FocusedField.")
    func nextFieldFunctionShouldReturnWithColor() {
        let focusedField = EditInformationView.FocusedField.race

        #expect(sut.nextField(focusedField: focusedField) == .color)
    }

    @Test("When FocusedField is .color, nextField() should return .eyeColor FocusedField.")
    func nextFieldFunctionShouldReturnWithEyeColor() {
        let focusedField = EditInformationView.FocusedField.color

        #expect(sut.nextField(focusedField: focusedField) == .eyeColor)
    }

    @Test("When FocusedField is .eyeColor, nextField() should return .chip FocusedField.")
    func nextFieldFunctionShouldReturnWithChip() {
        let focusedField = EditInformationView.FocusedField.eyeColor

        #expect(sut.nextField(focusedField: focusedField) == .chip)
    }

    @Test("When FocusedField is .chip, nextField() should return .chipLocation FocusedField.")
    func nextFieldFunctionShouldReturnWithChipLocation() {
        let focusedField = EditInformationView.FocusedField.chip

        #expect(sut.nextField(focusedField: focusedField) == .chipLocation)
    }

    @Test("When FocusedField is .chipLocation, nextField() should return .tatoo FocusedField.")
    func nextFieldFunctionShouldReturnWithTatoo() {
        let focusedField = EditInformationView.FocusedField.chipLocation

        #expect(sut.nextField(focusedField: focusedField) == .tatoo)
    }

    @Test("When FocusedField is .tatoo, nextField() should return .tatooLocation FocusedField.")
    func nextFieldFunctionShouldReturnWithTatooLocation() {
        let focusedField = EditInformationView.FocusedField.tatoo

        #expect(sut.nextField(focusedField: focusedField) == .tatooLocation)
    }

    @Test("When FocusedField is .tatooLocation, nextField() should return .toy FocusedField.")
    func nextFieldFunctionShouldReturnWithToy() {
        let focusedField = EditInformationView.FocusedField.tatooLocation

        #expect(sut.nextField(focusedField: focusedField) == .toy)
    }

    @Test("When FocusedField is .toy, nextField() should return .food FocusedField.")
    func nextFieldFunctionShouldReturnWithFood() {
        let focusedField = EditInformationView.FocusedField.toy

        #expect(sut.nextField(focusedField: focusedField) == .food)
    }

    @Test("When FocusedField is .food, nextField() should return .place FocusedField.")
    func nextFieldFunctionShouldReturnWithPlace() {
        let focusedField = EditInformationView.FocusedField.food

        #expect(sut.nextField(focusedField: focusedField) == .place)
    }

    @MainActor
    @Test("When we edit the pet, pet should be edited correctly.")
    func editPetShouldBeSuccessful() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer
        mockContainer.mainContext.autosaveEnabled = false

        #expect(throws: Never.self) {
            // When saving the pet, he must exist in the database already,
            // so we're creating it, otherwise, modification will not be saved
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)
            #expect(pets.count == 1)

            // Let's edit the current pet
            let testingPet = pets[0]
            sut.identification = Identification(chip: "1234", chipLocation: "Neck")
            sut.favorite = Favorite(toy: "Ball")
            #expect(self.sut.savePet(pet: testingPet, context: mockContainer.mainContext))

            // We're making a new context because the new fetch will look for the current
            // context first, and retrieve the pet, so we can't check if the save in
            // the persistent store worked
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let editedPets = try newContext.fetch(secondDescriptor)
            #expect(editedPets.count == 1)

            let editedPet = editedPets[0]

            #expect(editedPet.identification?.chip == "1234")
            #expect(editedPet.identification?.chipLocation == "Neck")
            #expect(editedPet.favorite?.toy == "Ball")
        }
    }

    @MainActor
    @Test("If savePet() throws, we want to check that the rollback worked.")
    func testIfPetRollbackInfosWorked() {
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

            sut.identification = Identification(chip: "1234", chipLocation: "Neck")
            sut.favorite = Favorite(toy: "Ball")

            mockSwiftDataHelper.saveShouldFail = true
            #expect(self.sut.savePet(pet: testingPet, context: mockContainer.mainContext) == false)

            let secondDescriptor = FetchDescriptor<Pet>()
            let editedPets = try mockContainer.mainContext.fetch(secondDescriptor)
            #expect(editedPets.count == 1)
            let editedPet = editedPets[0]

            #expect(testingPet.identification == nil)
            #expect(testingPet.favorite == nil)
            #expect(editedPet.identification == nil)
            #expect(editedPet.favorite == nil)

            // Now, let's make sure the changes didn't propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let thirdDescriptor = FetchDescriptor<Pet>()
            let notSavedPets = try newContext.fetch(thirdDescriptor)
            #expect(notSavedPets.count == 1)

            #expect(notSavedPets[0].identification == nil)
            #expect(notSavedPets[0].favorite == nil)
        }
    }
}
