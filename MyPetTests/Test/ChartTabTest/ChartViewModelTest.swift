//
//  ChartViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 11/12/2024.
//

import Foundation
import Testing
import SwiftData
@testable import MyPet

final class ChartViewModelTest {

    // MARK: PROPERTY
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private let sut: ChartView.ViewModel!

    // MARK: INIT
    init() {
        mockSwiftDataHelper = .init()
        sut = .init(swiftDataHelper: mockSwiftDataHelper)
    }

    // MARK: TEST
    @Test("With weight not nil, form should be valid")
    func formValidWithWeightNotNil() {
        sut.weight = 30.0
        #expect(sut.isFormValid)
    }

    @Test("With nil weight, form should not be valid")
    func formInvalidWithWeightNil() {
        #expect(sut.isFormValid == false)
    }

    @MainActor
    @Test("With weight not nil, pet should be saved")
    func petSavedWithWeightNotNil() {
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

            self.sut.weight = 25.0
            self.sut.addWeight(for: testingPet, context: mockContainer.mainContext)

            // Now, let's make sure the changes propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let savedPets = try newContext.fetch(secondDescriptor)

            #expect(savedPets.count == 1)
            #expect(savedPets[0].weights?.count == 1)

            guard let weights = savedPets[0].weights else {
                Issue.record("Pet weights should not be nil")
                return
            }

            #expect(weights.contains { $0.weight == 25.0 })
            #expect(self.sut.showingAlert == false)
            #expect(self.sut.errorMessage.isEmpty)
        }
    }

    @MainActor
    @Test("If saving the pet crashes, we should roll back weight infos")
    func whenSavePetCrashesWeShouldRollbackWeightInfos() {
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

            mockSwiftDataHelper.saveShouldFail = true
            self.sut.weight = 45.0
            sut.addWeight(for: testingPet, context: mockContainer.mainContext)

            // Let's see if we rolled back correctly
            #expect(pet.weights == nil)

            // Now, let's make sure the changes didn't propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let notSavedPets = try newContext.fetch(secondDescriptor)
            #expect(notSavedPets.count == 1)

            #expect(notSavedPets[0].weights == nil)
            #expect(self.sut.showingAlert)
            #expect(self.sut.errorMessage == """
            Oups, la sauvegarde ne s'est pas passée comme prévue, essayez de redémarrer l'application.
            """)
        }
    }

    @MainActor
    @Test("If weight is nil when addingPet(), then weight should not be added")
    func weightNotAddedIfWeightIsNil() {
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

            sut.addWeight(for: testingPet, context: mockContainer.mainContext)

            // Pet weights remains unchanged
            #expect(pet.weights == nil)

            // Same for container
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let notSavedPets = try newContext.fetch(secondDescriptor)
            #expect(notSavedPets.count == 1)

            #expect(notSavedPets[0].weights == nil)
            #expect(self.sut.showingAlert == false)
            #expect(self.sut.errorMessage.isEmpty)
        }
    }
}
