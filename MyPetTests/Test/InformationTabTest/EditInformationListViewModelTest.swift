//
//  EditInformationListViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 30/11/2024.
//

import Foundation
import Testing
import SwiftData
@testable import MyPet

final class EditInformationListViewModelTest {

    // MARK: PROPERTY
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private var sut: EditInformationListView.ViewModel!

    // MARK: INIT
    init() {
        self.mockSwiftDataHelper = MockSwiftDataHelper()
        self.sut = .init(swiftDataHelper: mockSwiftDataHelper)
    }

    // MARK: TEST
    @Test("With correct Information object, form should be valid.")
    func formShouldBeValid() {
        let pet = PetTest().pet
        sut.information = pet.information
        #expect(sut.isFormValid)
    }

    @Test("With nil Information object, form should be invalid.")
    func formShouldBeInvalid() {
        sut.information = nil
        #expect(sut.isFormValid == false)
    }

    @Test("When FocusedField is .name, nextField() should return .type FocusedField.")
    func nextFieldFunctionShouldReturnWithType() {
        let focusedField = EditInformationListView.FocusedField.name

        #expect(sut.nextField(focusedField: focusedField) == .type)
    }

    @Test("When FocusedField is .type, nextField() should return .race FocusedField.")
    func nextFieldFunctionShouldReturnWithRace() {
        let focusedField = EditInformationListView.FocusedField.type

        #expect(sut.nextField(focusedField: focusedField) == .race)
    }

    @Test("When FocusedField is .race, nextField() should return .color FocusedField.")
    func nextFieldFunctionShouldReturnWithColor() {
        let focusedField = EditInformationListView.FocusedField.race

        #expect(sut.nextField(focusedField: focusedField) == .color)
    }

    @Test("When FocusedField is .color, nextField() should return .eyeColor FocusedField.")
    func nextFieldFunctionShouldReturnWithEyeColor() {
        let focusedField = EditInformationListView.FocusedField.color

        #expect(sut.nextField(focusedField: focusedField) == .eyeColor)
    }

    @Test("When FocusedField is .eyeColor, nextField() should return .name FocusedField.")
    func nextFieldFunctionShouldReturnWithName() {
        let focusedField = EditInformationListView.FocusedField.eyeColor

        #expect(sut.nextField(focusedField: focusedField) == .name)
    }

    @MainActor
    @Test("When editing pet infos, pet should be saved with these infos.")
    func petShouldBeEditedCorrectly() {
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

            sut.information = testingPet.information
            sut.information?.name = "newName"

            // Saving the pet
            #expect(self.sut.savePet(pet: testingPet, context: mockContainer.mainContext))

            // We're making a new context because the new fetch will look for the current
            // context first, and retrieve the pet, so we can't check if the save in
            // the persistent store worked
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let editedPets = try newContext.fetch(secondDescriptor)
            #expect(editedPets.count == 1)

            // We ensure the pet has been modified
            let editedPet = editedPets[0]

            #expect(editedPet.information.name == "newName")
            #expect(self.sut.showingAlert == false)
            #expect(self.sut.errorMessage.isEmpty)
        }
    }

    @MainActor
    @Test("When savePet() throws, pet's infos should be rolled back.")
    func petShouldThrowAndRollback() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer
        mockSwiftDataHelper.saveShouldFail = true

        #expect(throws: Never.self) {
            // Let's add the pet, to control later that it has not been modified
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)
            #expect(pets.count == 1)

            let testingPet = pets[0]
            sut.information = testingPet.information
            sut.information?.name = "newName"

            // After the failed save, we retrieve the pet and we will
            // control the fields has not been modified
            #expect(self.sut.savePet(pet: testingPet, context: mockContainer.mainContext) == false)
            let secondDescriptor = FetchDescriptor<Pet>()
            let editedPets = try mockContainer.mainContext.fetch(secondDescriptor)
            #expect(editedPets.count == 1)

            let editedPet = editedPets[0]

            // The pet we retrieved after the failed save should not
            // have the new properties values
            #expect(editedPet.information.name == "testName")

            // Same goes with the original pet, we assure it not has been modified
            #expect(testingPet.information.name == "testName")

            // Now, let's make sure the changes didn't propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let thirdDescriptor = FetchDescriptor<Pet>()
            let notSavedPets = try newContext.fetch(thirdDescriptor)
            #expect(notSavedPets.count == 1)
            let notSavedPet = notSavedPets[0]

            #expect(notSavedPet.information.name == "testName")
            #expect(self.sut.showingAlert)
            #expect(self.sut.errorMessage == """
            Oups, la sauvegarde ne s'est pas passée comme prévue, essayez de redémarrer l'application.
            """)
        }
    }

    @MainActor
    @Test("If information is nil in sut, then we should not save the pet.")
    func petNotSavedIfInformationIsNil() {
        // Let's first setup our pet and the mockContainer
        let date = Date.now
        let pet = PetTest().pet
        pet.information.birthdate = date
        let mockContainer = MockContainer().mockContainer

        #expect(throws: Never.self) {
            // Let's add the pet, to control later that it has not been modified
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)
            #expect(pets.count == 1)

            let testingPet = pets[0]

            // After the failed save, we retrieve the pet and we will
            // control the fields has not been modified
            #expect(self.sut.savePet(pet: testingPet, context: mockContainer.mainContext))
            let secondDescriptor = FetchDescriptor<Pet>()
            let editedPets = try mockContainer.mainContext.fetch(secondDescriptor)
            #expect(editedPets.count == 1)

            let editedPet = editedPets[0]

            // The pet we retrieved after the failed save should not
            // have the new properties values
            #expect(editedPet.information.name == "testName")
            #expect(editedPet.information.gender == .male)
            #expect(editedPet.information.type == "testType")
            #expect(editedPet.information.race == "testRace")
            #expect(editedPet.information.birthdate == date)
            #expect(editedPet.information.color == "testColor")
            #expect(editedPet.information.eyeColor == "testEyeColor")

            // Same goes with the original pet, we assure it not has been modified
            #expect(testingPet.information.name == "testName")
            #expect(testingPet.information.gender == .male)
            #expect(testingPet.information.type == "testType")
            #expect(testingPet.information.race == "testRace")
            #expect(testingPet.information.birthdate == date)
            #expect(testingPet.information.color == "testColor")
            #expect(testingPet.information.eyeColor == "testEyeColor")

            // Now, let's make sure the changes didn't propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let thirdDescriptor = FetchDescriptor<Pet>()
            let notSavedPets = try newContext.fetch(thirdDescriptor)
            #expect(notSavedPets.count == 1)
            let notSavedPet = notSavedPets[0]

            #expect(notSavedPet.information.name == "testName")
            #expect(notSavedPet.information.gender == .male)
            #expect(notSavedPet.information.type == "testType")
            #expect(notSavedPet.information.race == "testRace")
            #expect(notSavedPet.information.birthdate == date)
            #expect(notSavedPet.information.color == "testColor")
            #expect(notSavedPet.information.eyeColor == "testEyeColor")

            #expect(self.sut.showingAlert == false)
            #expect(self.sut.errorMessage.isEmpty)
        }
    }
}
