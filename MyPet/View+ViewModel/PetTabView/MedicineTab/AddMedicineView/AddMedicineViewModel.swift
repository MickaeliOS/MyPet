//
//  AddMedicineViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import Foundation
import UserNotifications
import UIKit

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
        var takingTimes: [Medicine.TakingTime] = [.init(date: .now)]
        var multiDatePickerDateSet: Set<DateComponents> = []
        var selectedMedicineType = Medicine.MedicineType.pill
        var errorMessage = ""
        var showingAlert = false
        var notificationIDs: [String] = []
        let today = Calendar.current.startOfDay(for: Date.now)
        let userDefault = UserDefaults.standard
        private let center = UNUserNotificationCenter.current()

        // MARK: FUNCTION
        func createMedicineFlow() -> Medicine? {
            do {
                let lastDay = try calculateLastDay()
                var days: [DateComponents] = []

                if everyDay, duration != nil {
                    days = createDays(lastDay: lastDay)
                } else {
                    days = sortedDateComponentsSet(set: multiDatePickerDateSet)
                }

                let medicineDates = setupTakingTimesToDays(days: days)

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
            let settings = await center.notificationSettings()

            guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .ephemeral else {
                return
            }

            let pendingNotifications = await center.pendingNotificationRequests()

            guard let medicineDates = medicine.dates else {
                return
            }

            for dateComponents in medicineDates {
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

                if await isNewNotificationDateGreater(date: date, pendingNotifications: pendingNotifications) {
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

        private func setupTakingTimesToDays(days: [DateComponents]) -> [DateComponents] {
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
                try await center.add(request)
                notificationIDs.append(id)
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
            center.removeAllPendingNotificationRequests()
            userDefault.set(0, forKey: "badgeCount")

            var notificationsTransit = await NotificationHelper.convertPendingNotification()
            let newNotification = NotificationTransit(identifier: id, content: content, date: date, trigger: trigger)
            notificationsTransit.append(newNotification)
            let sortedNotifications = notificationsTransit.sorted { $0.date < $1.date }

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
                    try await center.add(newRequest)
                    if sortedNotification.identifier == newNotification.identifier {
                        notificationIDs.append(newID)
                    }
                } catch {
                    if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
                        badgeCount -= 1
                        userDefault.set(badgeCount, forKey: "badgeCount")
                    }
                }
            }
        }

        private func sortedDateComponentsSet(set: Set<DateComponents>) -> [DateComponents] {
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

        private func isNewNotificationDateGreater(
            date: Date,
            pendingNotifications: [UNNotificationRequest]
        ) async -> Bool {
            guard pendingNotifications.isEmpty == false else {
                return true
            }

            let allDatesAreEarlier = pendingNotifications.compactMap { request in
                (request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()
            }.allSatisfy { existingDate in
                date > existingDate
            }

            return allDatesAreEarlier ? true : false
        }
    }
}
