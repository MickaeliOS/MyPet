//
//  PetListViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 29/11/2024.
//

import Foundation
import Testing
import SwiftData
import UserNotifications
@testable import MyPet

final class PetListViewModelTest {
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private let sut: PetListView.ViewModel!
    private let notificationCenterMock: UNUserNotificationCenterMock!
    private let userDefaultMock: UserDefaultHelperMock!

    init() {
        mockSwiftDataHelper = .init()
        notificationCenterMock = .init()
        userDefaultMock = .init()

        self.sut = .init(swiftDataHelper: mockSwiftDataHelper,
                         notificationHelper: NotificationHelper(
                            center: notificationCenterMock,
                            userDefault: userDefaultMock))
    }

    private func setupNotifications(pet: Pet) async {

        // Checking if medicine and dates match with my PetTest setup.
        #expect(pet.medicine?.count == 1)
        #expect(pet.medicine?[0].dates?.count == 3)

        var ids: [String] = []

        for medicine in pet.medicine! {
            for date in medicine.dates! {
                let content = UNMutableNotificationContent()
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                let id = UUID().uuidString
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

                do {
                    try await notificationCenterMock.add(request)
                    ids.append(id)
                } catch {
                    Issue.record("Error adding mock notification.")
                }
            }
        }

        pet.medicine[0].notificationIDs?.append(ids)
    }

    @MainActor
    @Test("With notification auth + existing notification, it should be deleted.")
    func deletingNotificationShouldSucceed() async {
        let mockContainer = MockContainer().mockContainer

        // Setting up the pet and its medicine
        let pet = PetTest().pet
        pet.medicine = [PetTest.medicine]
        let pet2 = PetTest().pet2
        pet2.medicine = [PetTest.medicine2]

        await setupNotifications(pet: pet)
        await setupNotifications(pet: pet2)

        await #expect(throws: Never.self) {
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)

            // In order to give permission for user notifications, we use the swizzling method
            UNNotificationSettings.swizzleAuthorizationStatus()

            let indexSet = IndexSet(integer: 0)
            await sut.deletePet(at: indexSet, pets: [pet], context: mockContainer.mainContext)

            // Now, let's make sure the peg got deleted through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let deletePets = try newContext.fetch(secondDescriptor)
            #expect(deletePets.count == 0)
        }
    }
}
