//
//  AddMedicineViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import Foundation
import UserNotifications

extension AddMedicineView {

    // MARK: ENUM
    enum FocusedField {
        case name
        case dosage
        case additionalInformation
    }
    
    @Observable
    final class ViewModel {

        enum AddMedicineError: Error {
            case cannotCalculatedLastDay
            case cannotHandleNotification

            var errorDescription: String {
                switch self {
                case .cannotCalculatedLastDay:
                    return """
                    Oups, une erreur est survenue ! Veuillez vérifier
                    les jours sélectionnés, ou bien choisir \"Tous les jours\"
                    """
                case .cannotHandleNotification:
                    return "Impossible de planifier les notifications. Veuillez recommencer l'ajout du médicament."
                }
            }
        }
        
        // MARK: PROPERTY
        var medicineName = ""
        var medicineDosage = ""
        var additionalInformations = ""
        var everyDay = false
        var duration: Int?
        var takingTimes: [Medicine.TakingTime] = [.init(date: .now)]
        var medicineDates: Set<DateComponents> = []
        var selectedMedicineType = Medicine.MedicineType.pill
        var errorMessage = ""
        var showingAlert = false
        var notificationIDs: [String] = []
        let today = Calendar.current.startOfDay(for: Date.now)

        // MARK: FUNCTION
        func createMedicine() -> Medicine? {
            do {
                let lastDay = try calculateLastDay()

                return Medicine(
                    name: medicineName,
                    dosage: medicineDosage,
                    medicineType: selectedMedicineType,
                    everyDay: everyDay,
                    takingTimes: takingTimes,
                    dates: medicineDates,
                    additionalInformation: additionalInformations,
                    lastDay: lastDay,
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
                    throw AddMedicineError.cannotCalculatedLastDay
                }

                return lastDay

                // The second date mode, when the user picked his desired days.
                // The calculation is different from first mode.
            } else {
                let dates = medicineDates.compactMap { $0.date }

                if let lastDate = dates.sorted(by: <).last {
                    let startOfLastDate = Calendar.current.startOfDay(for: lastDate)

                    guard let fullLastDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfLastDate) else {
                        throw AddMedicineError.cannotCalculatedLastDay
                    }

                    return fullLastDate
                } else {
                    throw AddMedicineError.cannotCalculatedLastDay
                }
            }
        }

        func handleNotifications(medicine: Medicine, petName: String) {
            // If user is in first date mode, we have to build every dates
            // between start day to lastDay.
            if medicine.everyDay, duration != nil {
                var allDates: Set<DateComponents> = []
                var currentDate = today

                while currentDate < medicine.lastDay {
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
                    allDates.insert(dateComponent)

                    if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                        currentDate = nextDay
                    }
                }

                scheduleNotificationFlow(for: allDates, medicine: medicine, petName: petName)

                // Second date mode, we don't have to build every dates,
                // we already have them so the calculation is different.
            } else {
                guard let dates = medicine.dates else {
                    errorMessage = handleError(error: AddMedicineError.cannotHandleNotification)
                    showingAlert = true
                    return
                }

                scheduleNotificationFlow(for: dates, medicine: medicine, petName: petName)
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
        private func scheduleNotificationFlow(
            for dateComponents: Set<DateComponents>,
            medicine: Medicine,
            petName: String
        ) {
            for dateComponent in dateComponents {
                for takingTime in medicine.takingTimes {
                    do {
                        try scheduleNotification(
                            for: dateComponent,
                            at: takingTime.date,
                            medicine: medicine,
                            petName: petName
                        )
                    } catch let error {
                        errorMessage = handleError(error: error)
                        showingAlert = true
                    }
                }
            }
        }

        private func scheduleNotification(
            for dateComponents: DateComponents,
            at time: Date,
            medicine: Medicine,
            petName: String
        ) throws {
            // Setting up the Notification's Content
            let content = UNMutableNotificationContent()
            content.title = "Prise de médicament"
            content.body = "C'est le moment de donner \(medicine.name), \(medicine.dosage) à \(petName) !"
            content.sound = UNNotificationSound.default

            // Building the correct Date for the Notification
            var dateComponentsCopy = dateComponents
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            dateComponentsCopy.hour = timeComponents.hour
            dateComponentsCopy.minute = timeComponents.minute

            // Trigger's creation
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsCopy, repeats: false)

            // Notification is fully constructed with the Request
            let id = UUID().uuidString
            let request = UNNotificationRequest(
                identifier: id,
                content: content,
                trigger: trigger
            )

            // Adding the Notification in NotificationCenter
            UNUserNotificationCenter.current().add(request)
            notificationIDs.append(id)
        }

        private func handleError(error: Error) -> String {
            switch error {
            case let addMedicineError as AddMedicineError:
                return addMedicineError.errorDescription
            default:
                return "Un problème est survenu, veuillez réesayer."
            }
        }
    }
}
