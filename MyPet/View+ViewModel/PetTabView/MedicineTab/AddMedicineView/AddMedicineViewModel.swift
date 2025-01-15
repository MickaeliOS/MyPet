//
//  AddMedicineViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import Foundation
import UserNotifications
import UIKit
import SwiftData

extension AddMedicineView {

    // MARK: - ENUM
    enum FocusedField {
        case name
        case dosage
        case additionalInformation
    }

    enum AddMedicineError: Error {
        case cannotCalculateLastDay
        case cannotHandleNotification

        var errorDescription: String {
            switch self {
            case .cannotCalculateLastDay:
                return """
                Oups, une erreur est survenue ! Veuillez vérifier
                les jours sélectionnés, ou bien choisir \"Tous les jours\"
                """
            case .cannotHandleNotification:
                return "Impossible de planifier les notifications. Veuillez recommencer l'ajout du médicament."
            }
        }
    }

    // MARK: - VIEWMODEL
    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        var medicineName = ""
        var medicineDosage = ""
        var additionalInformations = ""
        var everyDay = false
        var duration: Int?
        var takingTimes: [Medicine.TakingTime] = [.init(date: Date.now)]
        var multiDatePickerDateSet: Set<DateComponents> = []
        var selectedMedicineType = Medicine.MedicineType.pill
        var errorMessage = ""
        var showingAlert = false
        var notificationIDs: [String] = []
        var today = Calendar.current.startOfDay(for: Date.now)
        let userDefault: UserDefaultHelperProtocol
        let notificationHelper: NotificationHelper
        let swiftDataHelper: SwiftDataProtocol

        // MARK: INIT
        init(userDefault: UserDefaultHelperProtocol = UserDefaultHelper(),
             notificationHelper: NotificationHelper,
             swiftDataHelper: SwiftDataProtocol = SwiftDataHelper()) {

            self.userDefault = userDefault
            self.notificationHelper = notificationHelper
            self.swiftDataHelper = swiftDataHelper
        }

        // MARK: FUNCTION
        func createMedicineFlow() -> Medicine? {
            do {
                let lastDay = try calculateLastDay()
                var days: [DateComponents] = []

                if duration != nil, everyDay {
                    days = createDays(lastDay: lastDay)
                } else {
                    days = sortedDateComponentsSet()
                }

                let medicineDates = attachTimeToDays(days: days)

                return Medicine(
                    name: medicineName,
                    dosage: medicineDosage,
                    medicineType: selectedMedicineType,
                    everyDay: everyDay,
                    takingTimes: takingTimes,
                    dates: medicineDates,
                    additionalInformation: additionalInformations,
                    lastDay: lastDay,
                    timeZone: .current,
                    notificationIDs: nil
                )
            } catch {
                errorMessage = handleError(error: error)
                showingAlert = true
                return nil
            }
        }

        func calculateLastDay() throws -> Date {

            // First date mode: if the user selected "Everyday", then we'll have to determine
            // the last day, for later to display how many days are left.
            if everyDay, let duration {
                guard let lastDay = Calendar.current.date(byAdding: .day, value: duration, to: today) else {
                    throw AddMedicineError.cannotCalculateLastDay
                }

                return lastDay

                // The second date mode, when the user picked his desired days.
                // The calculation is different from first mode.
            } else {
                let dates = multiDatePickerDateSet.compactMap { $0.date }

                if let lastDate = dates.sorted(by: <).last {
                    let startOfLastDate = Calendar.current.startOfDay(for: lastDate)

                    guard let fullLastDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfLastDate) else {
                        throw AddMedicineError.cannotCalculateLastDay
                    }

                    return fullLastDate
                } else {
                    throw AddMedicineError.cannotCalculateLastDay
                }
            }
        }

        func scheduleNotificationsFlow(medicine: Medicine, petName: String) async {
            let pendingNotifications = await notificationHelper.center.pendingNotificationRequests()

            for dateComponents in medicine.dates {
                guard let date = Calendar.current.date(from: dateComponents), date > Date.now else {
                    return
                }

                // Setting up the Notification's Content
                let content = UNMutableNotificationContent()
                content.title = "Prise de médicament"
                content.body = "C'est le moment de donner \(medicine.name), \(medicine.dosage) à \(petName) !"
                content.sound = UNNotificationSound.default

                // Trigger's creation
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

                // ID
                let id = UUID().uuidString

                // We must be sure that the badge count is in order
                let result = await notificationHelper.isNewNotificationDateGreater(
                    date: date,
                    pendingNotifications: pendingNotifications
                )

                if result {
                    await addGreaterDateNotification(id: id, content: content, trigger: trigger)
                } else {
                    await addLowerDateNotification(id: id, content: content, date: date, trigger: trigger)
                }
            }
        }

        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .dosage,
                .dosage: .additionalInformation
            ]

            return transitions[focusedField] ?? .name
        }

        func savePet(context: ModelContext) -> Bool {
            do {
                try swiftDataHelper.save(with: context)
                return true
            } catch {
                errorMessage = error.description
                showingAlert = true
                return false
            }
        }

        func deleteNotifications() {
            notificationHelper.center.removePendingNotificationRequests(withIdentifiers: notificationIDs)
        }

        // MARK: PRIVATE FUNCTION
        private func handleError(error: Error) -> String {
            switch error {
            case let addMedicineError as AddMedicineError:
                return addMedicineError.errorDescription
            default:
                return "Un problème est survenu, veuillez réesayer."
            }
        }

        private func createDays(lastDay: Date) -> [DateComponents] {
            var allDates: [DateComponents] = []

            // If user is in first date mode, we have to build every dates
            // between start day to lastDay.
            if everyDay, duration != nil {
                var currentDate = today

                while currentDate < lastDay {
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
                    allDates.append(dateComponent)

                    if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                        currentDate = nextDay
                    }
                }
            }

            return allDates
        }

        private func attachTimeToDays(days: [DateComponents]) -> [DateComponents] {
            var updatedArray: [DateComponents] = []

            days.forEach { dateComponents in
                takingTimes.forEach { takingTime in
                    let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: takingTime.date)
                    var dateComponentsCopy = dateComponents

                    dateComponentsCopy.hour = timeComponents.hour
                    dateComponentsCopy.minute = timeComponents.minute
                    dateComponentsCopy.timeZone = TimeZone.current

                    updatedArray.append(dateComponentsCopy)
                }
            }

            return updatedArray
        }

        private func addGreaterDateNotification(
            id: String,
            content: UNMutableNotificationContent,
            trigger: UNCalendarNotificationTrigger
        ) async {
            // Badge handling
            if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
                badgeCount += 1
                userDefault.set(badgeCount, forKey: "badgeCount")
                content.badge = NSNumber(value: badgeCount)
            } else {
                userDefault.set(1, forKey: "badgeCount")
                content.badge = 1
            }

            // Notification is fully constructed with the Request
            let request = UNNotificationRequest(
                identifier: id,
                content: content,
                trigger: trigger
            )

            // Adding the Notification in NotificationCenter
            do {
                try await notificationHelper.center.add(request)
                await controlNotification(id: id)
            } catch {
                if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
                    badgeCount -= 1
                    userDefault.set(badgeCount, forKey: "badgeCount")
                }
            }
        }

        private func addLowerDateNotification(
            id: String,
            content: UNMutableNotificationContent,
            date: Date,
            trigger: UNCalendarNotificationTrigger
        ) async {
            userDefault.set(0, forKey: "badgeCount")

            var notificationsTransit = await notificationHelper.convertPendingNotification()
            let newNotification = NotificationTransit(identifier: id, content: content, date: date, trigger: trigger)
            notificationsTransit.append(newNotification)
            let sortedNotifications = notificationsTransit.sorted { $0.date < $1.date }

            notificationHelper.center.removeAllPendingNotificationRequests()

            for sortedNotification in sortedNotifications {
                // New Content
                let newContent = UNMutableNotificationContent()
                newContent.title = sortedNotification.content.title
                newContent.body = sortedNotification.content.body
                newContent.sound = sortedNotification.content.sound

                // New Trigger
                let newTrigger = sortedNotification.trigger

                // New ID
                let newID = sortedNotification.identifier

                // Badge handling
                if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
                    badgeCount += 1
                    userDefault.set(badgeCount, forKey: "badgeCount")
                    newContent.badge = NSNumber(value: badgeCount)
                } else {
                    userDefault.set(1, forKey: "badgeCount")
                    newContent.badge = 1
                }

                // Notification is fully constructed with the Request
                let newRequest = UNNotificationRequest(
                    identifier: newID,
                    content: newContent,
                    trigger: newTrigger
                )

                // Adding the Notification in NotificationCenter
                do {
                    try await notificationHelper.center.add(newRequest)

                    if sortedNotification.identifier == newNotification.identifier {
                        await controlNotification(id: id)
                    }
                } catch {
                    if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
                        badgeCount -= 1
                        userDefault.set(badgeCount, forKey: "badgeCount")
                    }
                }
            }
        }

        private func sortedDateComponentsSet() -> [DateComponents] {
            return multiDatePickerDateSet
                .compactMap { dateComponents in
                    dateComponents.date.map { date in
                        (dateComponents, date)
                    }
                }
                .sorted { firstTuple, secondTuple in
                    firstTuple.1 < secondTuple.1
                }
                .map { tuple in
                    tuple.0
                }
        }

        private func controlNotification(id: String) async {
            let pendingNotifications = await notificationHelper.center.pendingNotificationRequests()

            if pendingNotifications.contains(where: { $0.identifier == id }) {
                notificationIDs.append(id)
            } else {
                if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
                    badgeCount -= 1
                    userDefault.set(badgeCount, forKey: "badgeCount")
                }
            }
        }
    }
}
