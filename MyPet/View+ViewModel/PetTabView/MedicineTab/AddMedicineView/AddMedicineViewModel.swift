//
//  AddMedicineViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import Foundation

extension AddMedicineView {

    @Observable
    final class ViewModel {
        var medicineName = ""
        var medicineDosage = ""
        var additionalInformations = ""
        var everyDay = false
        var duration: Int?
        var takingTimes: [Date] = [Date()]
        var medicineDates: Set<DateComponents> = []
        var selectedMedicineType = Medicine.MedicineCategory.pill

        var errorMessage = ""
        var showingAlert = false

        func createMedicine() -> Medicine? {
            do {
                let lastDay = try calculateLastDay()
                var medicine =  Medicine(
                    name: medicineName,
                    dosage: medicineDosage,
                    medicineTypeImageName: selectedMedicineType,
                    everyDay: everyDay,
                    takingTimes: takingTimes
                )

                medicine.lastDay = lastDay
                medicine.additionalInformation = additionalInformations

                return medicine
            } catch {
                errorMessage = handleError(error: error)
                showingAlert = true
                return nil
            }
        }

        func calculateLastDay() throws -> Date {
            let today = Date.now

            if everyDay, let duration {
                guard let lastDay = Calendar.current.date(byAdding: .day, value: duration, to: today) else {
                    throw AddMedicineError.cannotCalculatedLastDay
                }

                return lastDay
            } else {
                let dates = medicineDates.compactMap { $0.date }

                if let lastDate = dates.sorted(by: <).last {
                    return lastDate
                } else {
                    throw AddMedicineError.cannotCalculatedLastDay
                }
            }
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

    enum AddMedicineError: Error {
        case cannotCalculatedLastDay

        var errorDescription: String {
            switch self {
            case .cannotCalculatedLastDay:
                return """
                Oups, une erreur est survenue ! Veuillez vérifier
                les jours sélectionnés, ou bien choisir \"Tous les jours\"
                """
            }
        }
    }
}
