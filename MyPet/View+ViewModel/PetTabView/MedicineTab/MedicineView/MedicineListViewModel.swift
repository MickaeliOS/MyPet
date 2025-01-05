//
//  MedicineListViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 21/11/2024.
//

import Foundation
import SwiftData
import UserNotifications

extension MedicineListView {

    // MARK: - ENUM
    enum MedicineListViewError: Error {
        case cannotDeleteWithoutNotificationsAuth

        var description: String {
            switch self {
            case .cannotDeleteWithoutNotificationsAuth:
                """
                Vous essayez de supprimer un ou plusieurs médicaments contenant des notifications.
                Veuillez d'abord autoriser les notifications dans les réglages de l'appareil afin de les supprimer.
                """
            }
        }
    }

    // MARK: - VIEW MODEL
    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        var errorMessage = ""
        var showingAlert = false
        private let notificationHelper = NotificationHelper()
        private let center = UNUserNotificationCenter.current()

        // MARK: FUNCTION
        @MainActor
        func deleteMedicine(pet: Pet, context: ModelContext, sortedMedicineList: [Medicine], offsets: IndexSet) async {

            if sortedMedicineList.contains(where: { $0.notificationIDs != nil }),
               await !notificationHelper.areNotificationsAuthorized() {

                errorMessage = MedicineListViewError.cannotDeleteWithoutNotificationsAuth.description
                showingAlert = true
                return
            }

            guard let medicineCopy = pet.medicine else {
                return
            }

            pet.deleteMedicineFromOffSets(with: sortedMedicineList, offsets: offsets)

            do {
                try SwiftDataHelper().save(with: context)
                deleteNotifications(medicines: medicineCopy, offsets: offsets)
                rescheduleNotifications()
            } catch {
                pet.medicine = medicineCopy
                errorMessage = error.description
                showingAlert = true
            }
        }

        private func deleteNotifications(medicines: [Medicine], offsets: IndexSet) {
            for offset in offsets {
                guard let notificationsIDs = medicines[offset].notificationIDs else {
                    return
                }

                center.removePendingNotificationRequests(withIdentifiers: notificationsIDs)
            }
        }

        private func rescheduleNotifications() {
//            if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
//                badgeCount = 0
//                userDefault.set(badgeCount, forKey: "badgeCount")
//            }

            Task { @MainActor in
                await notificationHelper.reschedulePendingNotifications()
            }
        }
    }
}
