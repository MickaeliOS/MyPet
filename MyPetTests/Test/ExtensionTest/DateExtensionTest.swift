//
//  DateExtensionTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 08/01/2025.
//

import Foundation
import Testing
@testable import MyPet

final class DateExtensionTest {
    @Test("Converting from Date to dateToStringDMY succeed.")
    func dateToStringDMYSucceed() {
        // Given a date
        let calendar = Calendar.current
        let components = DateComponents(year: 2025, month: 1, day: 5)

        guard let date = calendar.date(from: components) else {
            Issue.record("Date should not be nil.")
            return
        }

        // When converting the date in string format
        let result = date.dateToStringDMY

        // Then expected format is returned
        #expect(result == "05/01/2025")
    }
}
