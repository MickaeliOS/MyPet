//
//  EditVeterinarianViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 11/12/2024.
//

import Foundation
import Testing
import SwiftData
@testable import MyPet

final class EditVeterinarianViewModelTest {

    // MARK: PROPERTY
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private let sut: EditVeterinarianView.ViewModel!

    // MARK: INIT
    init() {
        mockSwiftDataHelper = .init()
        sut = .init(swiftDataHelper: mockSwiftDataHelper)
    }

    // MARK: TEST
    @Test("When FocusedField is .name, nextField() should return .address FocusedField.")
    func nextFieldFunctionShouldReturnWithAddress() {
        let focusedField = EditVeterinarianView.FocusedField.name

        #expect(sut.nextField(focusedField: focusedField) == .address)
    }

    @Test("When FocusedField is .address, nextField() should return .phone FocusedField.")
    func nextFieldFunctionShouldReturnWithPhone() {
        let focusedField = EditVeterinarianView.FocusedField.address

        #expect(sut.nextField(focusedField: focusedField) == .phone)
    }

    @Test("When FocusedField is .phone, nextField() should return .website FocusedField.")
    func nextFieldFunctionShouldReturnWithWebsite() {
        let focusedField = EditVeterinarianView.FocusedField.phone

        #expect(sut.nextField(focusedField: focusedField) == .website)
    }

    @Test("When FocusedField is .website, nextField() should return .name FocusedField.")
    func nextFieldFunctionShouldReturnWithName() {
        let focusedField = EditVeterinarianView.FocusedField.website

        #expect(sut.nextField(focusedField: focusedField) == .name)
    }

    @MainActor
    @Test("When adding veterinarian infos, pet is saved with these new infos.")
    func petShouldBeSavedAfterVeteriarianInfosAdded() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer

        #expect(throws: Never.self) {
            // When saving the pet, he must exist in the database already,
            // so we're creating it, otherwise, modification will not be saved
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)

            self.sut.veterinarian = Veterinarian(name: "MyVeterinarian")
            #expect(self.sut.savePet(pet: pet, context: mockContainer.mainContext))

            // Now, let's make sure the changes propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let savedPets = try newContext.fetch(secondDescriptor)

            #expect(savedPets.count == 1)
            #expect(savedPets[0].veterinarian?.name == "MyVeterinarian")
            #expect(self.sut.showingAlert == false)
            #expect(self.sut.errorMessage.isEmpty)
        }
    }

    @MainActor
    @Test("If saving the pet crashes, we should roll back veterinarian infos")
    func veterinarianInfosShouldBeRolledBackIfSaveCrashes() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer

        #expect(throws: Never.self) {
            // When saving the pet, he must exist in the database already,
            // so we're creating it, otherwise, modification will not be saved
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)

            mockSwiftDataHelper.saveShouldFail = true
            self.sut.veterinarian = Veterinarian(name: "MyVet")

            #expect(self.sut.savePet(pet: pet, context: mockContainer.mainContext) == false)

            // Let's see if we rolled back correctly
            #expect(pet.veterinarian == nil)

            // Now, let's make sure the changes didn't propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let notSavedPets = try newContext.fetch(secondDescriptor)
            #expect(notSavedPets.count == 1)

            #expect(notSavedPets[0].veterinarian == nil)
            #expect(self.sut.showingAlert)
            #expect(self.sut.errorMessage == """
            Oups, la sauvegarde ne s'est pas passée comme prévue, essayez de redémarrer l'application.
            """)
        }
    }
}
