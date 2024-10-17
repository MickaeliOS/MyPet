//
//  CalendarExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 17/09/2024.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and: Date) -> Int? {
        let correctTimeZone = and.convertToTimeZone(
            initTimeZone: TimeZone.current,
            timeZone: TimeZone(identifier: "Europe/Paris")!
        )
        
        let numberOfDays = dateComponents([.day], from: from, to: correctTimeZone)
        return numberOfDays.day
    }
}
