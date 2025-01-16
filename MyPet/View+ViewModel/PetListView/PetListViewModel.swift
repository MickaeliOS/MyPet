//
//  PetListViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 21/11/2024.
//

import Foundation
import SwiftData
import UserNotifications

extension PetListView {

    // MARK: - ENUM
    enum PetListViewError: Error {
        case cannotDeleteWithoutNotificationsAuth

        var description: String {
            switch self {
            case .cannotDeleteWithoutNotificationsAuth:
                """
                Vous essayez de supprimer un ou plusieurs animaux ayant des notifications de médicaments.
                Veuillez d'abord autoriser les notifications dans les réglages de l'appareil afin de les supprimer.
                """
            }
        }
    }

    // MARK: - VIEW MODEL
    @Observable
    final class ViewModel {
        var errorMessage = ""
        var showingAlert = false
        var swiftDataHelper: SwiftDataProtocol
        private let notificationHelper: NotificationHelper
        private let center: UNUserNotificationCenterProtocol

        // MARK: INIT
        init(
            swiftDataHelper: SwiftDataProtocol = SwiftDataHelper(),
            notificationHelper: NotificationHelper,
            center: UNUserNotificationCenterProtocol = UNUserNotificationCenterHelper()
        ) {
            self.swiftDataHelper = swiftDataHelper
            self.notificationHelper = notificationHelper
            self.center = center
        }

        @MainActor
        func deletePet(at offsets: IndexSet, pets: [Pet], context: ModelContext) async {
            if doPetHaveNotifications(pets: pets, offsets: offsets),
               await !notificationHelper.areNotificationsAuthorized() {
                errorMessage = PetListViewError.cannotDeleteWithoutNotificationsAuth.description
                showingAlert = true
                return
            }

            var petsCopy: [Pet] = []

            for offset in offsets {
                let pet = pets[offset]
                petsCopy.append(pet)
                context.delete(pet)
            }

            do {
                try swiftDataHelper.save(with: context)

                petsCopy.forEach { pet in
                    pet.deletePetNotifications(center: center)
                }

                rescheduleNotifications()
            } catch {
                context.rollback()
                errorMessage = error.description
                showingAlert = true
            }
        }

        private func doPetHaveNotifications(pets: [Pet], offsets: IndexSet) -> Bool {
            var result = false

            for offset in offsets {
                guard let medicine = pets[offset].medicine else { continue }

                if medicine.contains(where: { $0.notificationIDs != nil }) {
                    result = true
                    break
                }
            }

            return result
        }

        private func rescheduleNotifications() {
            Task { @MainActor in
                await notificationHelper.reschedulePendingNotifications()
            }
        }
    }
}
