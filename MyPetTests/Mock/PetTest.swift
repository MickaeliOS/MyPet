//
//  PetTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 08/12/2024.
//

import Foundation
@testable import MyPet

struct PetTest {
    let pet = Pet(information: Information(
        name: "testName",
        gender: .male,
        type: "testType",
        race: "testRace",
        birthdate: Date.now,
        color: "testColor",
        eyeColor: "testEyeColor"
    ))

    let pet2 = Pet(information: Information(
        name: "testName2",
        gender: .female,
        type: "testType2",
        race: "testRace2",
        birthdate: Date.now,
        color: "testColor2",
        eyeColor: "testEyeColor2"
    ))

//    static var medicine: Medicine {
//
//        // Setting up the days
//        let today = Calendar.current.startOfDay(for: .now)
//        let lastDay = Calendar.current.date(byAdding: .day, value: 3, to: today)!
//        let days = Medicine.createDays(today: today, lastDay: lastDay)
//
//        // Setting up the time
//        var dateComponents = DateComponents()
//        dateComponents.hour = 6
//        dateComponents.minute = 0
//        let takingTimeDate = Calendar.current.date(from: dateComponents)!
//        let takingTime = Medicine.TakingTime(date: takingTimeDate)
//
//        // Complete dates (days + times)
//        let dates = Medicine.TakingTime.attachTimeToDays(time: [takingTime], days: days)
//
//        return Medicine(
//            name: "MedTest",
//            dosage: "DosageTest",
//            medicineType: .bottle,
//            everyDay: true,
//            takingTimes: [takingTime],
//            dates: dates,
//            additionalInformation: nil,
//            lastDay: lastDay,
//            timeZone: .current
//        )
//    }
//
//    static var medicine2: Medicine {
//
//        // Setting up the days
//        let today = Calendar.current.startOfDay(for: .now)
//        let lastDay = Calendar.current.date(byAdding: .day, value: 2, to: today)!
//        let days = Medicine.createDays(today: today, lastDay: lastDay)
//
//        // Setting up the time
//        var dateComponents = DateComponents()
//        dateComponents.hour = 18
//        dateComponents.minute = 0
//        let takingTimeDate = Calendar.current.date(from: dateComponents)!
//        let takingTime = Medicine.TakingTime(date: takingTimeDate)
//
//        // Complete dates (days + times)
//        let dates = Medicine.TakingTime.attachTimeToDays(time: [takingTime], days: days)
//
//        return Medicine(
//            name: "MedTest2",
//            dosage: "DosageTest2",
//            medicineType: .bottle,
//            everyDay: true,
//            takingTimes: [takingTime],
//            dates: dates,
//            additionalInformation: nil,
//            lastDay: lastDay,
//            timeZone: .current
//        )
//    }
}
