//
//  WeightHistoryViewModel.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 11/12/2024.
//

import Foundation
import Testing
import SwiftData
@testable import MyPet

final class WeightHistoryViewModelTest {

    // MARK: PROPERTY
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private let sut: WeightHistoryView.ViewModel!

    // MARK: INIT
    init() {
        mockSwiftDataHelper = .init()
        sut = .init(swiftDataHelper: mockSwiftDataHelper)
    }

    // MARK: TEST
    @MainActor
    @Test("Delete weight should work with a weight to delete")
    func deleteWeightWorksIfWeightIsHere() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        pet.weights = []
        pet.addWeight(weight: Weight(day: .now, weight: 10.0))
        let mockContainer = MockContainer().mockContainer

        #expect(throws: Never.self) {
            // When saving the pet, he must exist in the database already,
            // so we're creating it, otherwise, modification will not be saved
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)
            #expect(pets.count == 1)
            let testingPet = pets[0]

            let indexSet = IndexSet(integer: 0)
            self.sut.deleteWeight(pet: testingPet, offsets: indexSet, context: mockContainer.mainContext)

            // Now, let's make sure the changes propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let deletedPetWeight = try newContext.fetch(secondDescriptor)

            #expect(deletedPetWeight[0].weights?.isEmpty ?? false)
            #expect(self.sut.showingAlert == false)
            #expect(self.sut.errorMessage.isEmpty)
        }
    }

    @MainActor
    @Test("If deleteWeight crashes, we should rollback weights infos")
    func weightInfosRolledbackIfDeleteWeightCrashes() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        pet.weights = []
        pet.addWeight(weight: Weight(day: .now, weight: 10.0))
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
            let indexSet = IndexSet(integer: 0)
            self.sut.deleteWeight(pet: testingPet, offsets: indexSet, context: mockContainer.mainContext)

            #expect(pet.weights?.count == 1)
            #expect(pet.weights?[0].weight == 10.0)

            // Now, let's make sure the changes propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let notDeletedPetWeight = try newContext.fetch(secondDescriptor)

            #expect(notDeletedPetWeight[0].weights?.count == 1)
            #expect(notDeletedPetWeight[0].weights?[0].weight == 10.0)
            #expect(self.sut.showingAlert)
            #expect(self.sut.errorMessage == """
            Oups, la sauvegarde ne s'est pas passée comme prévue, essayez de redémarrer l'application.
            """)
        }
    }
}
