//
//  CalendarExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 17/09/2024.
//

import Foundation

extension Calendar {

    // MARK: FUNCTION
//    func numberOfDaysBetween(_ startDate: Date, and endDate: Date, from timeZone: TimeZone) -> Int? {
//        var components = DateComponents()
//        components.calendar = .current
//        components.timeZone = timeZone
//
//        guard let startOfDay = components.calendar?.startOfDay(for: startDate) else {
//            return nil
//        }
//
//        let numberOfDays = dateComponents([.day], from: startOfDay, to: endDate)
//        return numberOfDays.day
//    }

    func numberOfDaysBetween(_ startDate: Date, and endDate: Date) -> Int? {
        let numberOfDays = dateComponents([.day], from: startDate, to: endDate)
        return numberOfDays.day
    }

}
