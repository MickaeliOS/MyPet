//
//  Pet.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/08/2024.
//

import Foundation
import SwiftData
import UserNotifications

@Model
final class Pet {
    var information: Information
    var identification: Identification?
    var favorite: Favorite?
    var veterinarian: Veterinarian?
    var health: Health?
    var medicine: [Medicine]?
    var weights: [Weight]?

    init(
        information: Information,
        identification: Identification? = nil,
        favorite: Favorite? = nil,
        veterinarian: Veterinarian? = nil,
        health: Health? = nil,
        medicine: [Medicine]? = nil,
        weights: [Weight]? = nil
    ) {
        self.information = information
        self.identification = identification
        self.favorite = favorite
        self.veterinarian = veterinarian
        self.health = health
        self.medicine = medicine
        self.weights = nil
    }
}

extension Pet {
    func addMedicine(medicine: Medicine) {
        self.medicine?.append(medicine)
    }

    func deleteMedicineFromOffSets(with medicineList: [Medicine], offsets: IndexSet) {
        for offset in offsets {
            if let index = medicine?.firstIndex(of: medicineList[offset]) {
                medicine?.remove(at: index)
            }
        }
    }

    func deleteNotifications(with medicineList: [Medicine], offsets: IndexSet) {
        for offset in offsets {
            if let index = medicine?.firstIndex(of: medicineList[offset]) {
                if let notificationsToDelete = medicine?[index].notificationIDs {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(
                        withIdentifiers: notificationsToDelete
                    )
                }
            }
        }
    }

    func addWeight(weight: Weight) {
        if let index = self.weights?.firstIndex(where: { $0.day > weight.day }) {
            self.weights?.insert(weight, at: index)
        } else {
            self.weights?.append(weight)
        }
    }

    func deleteWeight(offsets: IndexSet) {
        weights?.remove(atOffsets: offsets)
    }

//    func sortMedicineByTakingTime() {
//        medicine?.forEach({ medicine in
//            medicine.takingTimes = medicine.takingTimes.sorted(by: <)
//        })
//    }
}
