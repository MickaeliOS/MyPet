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

    // MARK: PROPERTY
    var information: Information
    var identification: Identification?
    var favorite: Favorite?
    var veterinarian: Veterinarian?
    var health: Health?
    var medicine: [Medicine]?
    var weights: [Weight]?
    var center: UNUserNotificationCenterProtocol

    // MARK: INIT
    init(
        information: Information,
        identification: Identification? = nil,
        favorite: Favorite? = nil,
        veterinarian: Veterinarian? = nil,
        health: Health? = nil,
        medicine: [Medicine]? = nil,
        weights: [Weight]? = nil,
        center: UNUserNotificationCenterProtocol = UNUserNotificationCenterHelper()
    ) {
        self.information = information
        self.identification = identification
        self.favorite = favorite
        self.veterinarian = veterinarian
        self.health = health
        self.medicine = medicine
        self.weights = nil
        self.center = center
    }
}

// MARK: EXTENSION
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

    func deletePetNotifications(center: UNUserNotificationCenterProtocol) {
        medicine?.forEach({ med in
            guard let notificationIDs = med.notificationIDs else {
                return
            }

            center.removePendingNotificationRequests(withIdentifiers: notificationIDs)
        })
    }

//    // Old working version, new one changed to help for unit test with the protocol
//    func deletePetNotifications() {
//        medicine?.forEach({ med in
//            let notificationCenter = UNUserNotificationCenter.current()
//
//            guard let notificationIDs = med.notificationIDs else {
//                return
//            }
//
//            notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIDs)
//        })
//    }

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
}
