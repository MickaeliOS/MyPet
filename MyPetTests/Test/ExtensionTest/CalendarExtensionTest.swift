//
//  CalendarExtensionTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 09/01/2025.
//

import Foundation
import Testing
@testable import MyPet

final class CalendarExtensionTest {
    @Test("Number of days between 2 days should be 2.")
    func numberOfDaysBetween2DaysReturns2() {
        var components = DateComponents()
        components.calendar = Calendar.current

        guard let startOfDay = components.calendar?.startOfDay(for: Date.now) else {
            Issue.record("startOfDay should not be nil.")
            return
        }

        guard let lastDay = Calendar.current.date(byAdding: .day, value: 2, to: startOfDay) else {
            Issue.record("lastDay should not be nil.")
            return
        }

        let daysBetween = Calendar.current.numberOfDaysBetween(startOfDay, and: lastDay)

        #expect(daysBetween == 2)
    }
}
