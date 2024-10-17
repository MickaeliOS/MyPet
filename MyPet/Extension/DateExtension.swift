//
//  DateExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 15/08/2024.
//

import Foundation

extension Date {
    var dateToStringDMY: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }

    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
