//
//  PetListViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 29/11/2024.
//

import Foundation
import Testing
import SwiftData
@testable import MyPet

/*
 Trouver un moyen de mock UNNotificationCenter.
 petShouldBeRemovedAfterDelete() en suspends le temps de trouver.
 */

struct PetListViewModelTest {
    private let sut = PetListView.ViewModel()

//    @MainActor @Test("After adding a Pet, deletePet() method should delete the pet.")
//    func petShouldBeRemovedAfterDelete() async {
//
//        // deletePet() parameter setup
//        let indexSet = IndexSet(integer: 0)
//        let pet = Pet(
//            information: Information(
//                name: "testName",
//                gender: .male,
//                type: "testType",
//                race: "testRace",
//                birthdate: .now,
//                color: "testColor",
//                eyeColor: "testEyeColor"
//            )
//        )
//        let mockContainer = MockContainer().mockContainer
//
//        await #expect(throws: Never.self) {
//
//            // Insert before deletion
//            mockContainer.mainContext.insert(pet)
//
//            try mockContainer.mainContext.save()
//
//            let descriptor = FetchDescriptor<Pet>()
//            let pets = try mockContainer.mainContext.fetch(descriptor)
//            #expect(pets.count == 1)
//
//            // Deletion
//            await sut.deletePet(at: indexSet, pets: pets, context: mockContainer.mainContext)
//            let petss = try mockContainer.mainContext.fetch(descriptor)
//            #expect(petss.count == 0)
//        }
//    }
}
