//
//  Medicine.swift
//  MyPet
//
//  Created by Mickaël Horn on 02/09/2024.
//

import Foundation

struct Medicine: Codable, Hashable, Identifiable {
    var id = UUID()
    let name: String
    let dosage: String
    let medicineType: MedicineType
    let everyDay: Bool
    let takingTimes: [TakingTime]
    let dates: Set<DateComponents>?
    let additionalInformation: String?
    let lastDay: Date
    var notificationIDs: [String]?
}

extension Medicine {
    struct TakingTime: Codable, Hashable, Identifiable {
        var id = UUID()
        var date: Date
    }
}
extension Medicine {
    enum MedicineType: CaseIterable, Codable {
        case pill
        case syringe
        case bottle

        var imageSystemName: String {
            switch self {
            case .pill:
                "pills.circle.fill"
            case .syringe:
                "syringe.fill"
            case .bottle:
                "cross.vial.fill"
            }
        }
    }
}

extension Medicine {
    static let sampleMedicine = Medicine(
        name: "Medicine",
        dosage: "10mg",
        medicineType: .bottle,
        everyDay: true,
        takingTimes: [
            TakingTime(date: Date()),
            TakingTime(date: Date())
        ],
        dates: nil,
        additionalInformation: "After lunch.",
        lastDay: .now,
        notificationIDs: nil
    )
}
