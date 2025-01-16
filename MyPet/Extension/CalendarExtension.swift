//
//  CalendarExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 17/09/2024.
//

import Foundation

extension Calendar {

    // MARK: FUNCTION
    func numberOfDaysBetween(_ startDate: Date, and endDate: Date) -> Int? {
        let numberOfDays = dateComponents([.day], from: startDate, to: endDate)
        return numberOfDays.day
    }
}
