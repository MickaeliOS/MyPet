//
//  AddMedicineViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 19/12/2024.
//

import Foundation
import Testing
@testable import MyPet
import UserNotifications
import SwiftData

final class AddMedicineViewModelTest {

    // MARK: PROPERTY
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private let sut: AddMedicineView.ViewModel!

    // MARK: INIT
    init() {
        mockSwiftDataHelper = MockSwiftDataHelper()
        let userDefaultMock = UserDefaultHelperMock()
        let centerMock = UNUserNotificationCenterMock()
        self.sut = .init(userDefault: userDefaultMock,
                         notificationHelper: NotificationHelper(
                            center: centerMock,
                            userDefault: userDefaultMock
                         ),
                         swiftDataHelper: mockSwiftDataHelper
        )

        // I'm doing this for clarity about the notification part.
        // I'm sure this future date won't be outdated when setting up notifications.
        guard let baseDate = Calendar.current.date(byAdding: .year, value: 1, to: Date.now) else {
            Issue.record("baseDate should be correct.")
            return
        }

        sut.today = Calendar.current.startOfDay(for: baseDate)
    }

    // MARK: PRIVATE FUNCTIONS
    private func setupTakingTime() {
        var dateComponents = Calendar.current.dateComponents([.day], from: Date.now)
        dateComponents.hour = 6
        dateComponents.minute = 0

        guard let takingTime = Calendar.current.date(from: dateComponents) else {
            Issue.record("Error, the date should not be nil.")
            return
        }

        sut.takingTimes = [.init(date: takingTime)]
    }

    private func setupDates(with today: Date) -> Set<DateComponents> {
        let calendar = Calendar.current

        guard let firstDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            Issue.record("secondDate invalid.")
            return []
        }

        guard let secondDate = calendar.date(byAdding: .day, value: 1, to: firstDate) else {
            Issue.record("secondDate invalid.")
            return []
        }

        var firstDateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: firstDate)
        var secondDateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: secondDate)
        firstDateComponents.calendar = calendar
        secondDateComponents.calendar = calendar

        return [firstDateComponents, secondDateComponents]
    }

    private func setupSampleNotifications() async {
        let today = Date.now

        for index in 1...2 {
            guard let notificationDate = Calendar.current.date(byAdding: .month, value: index, to: today) else {
                Issue.record("notificationDate should be correct.")
                return
            }

            let firstNotificationDateComponents = Calendar.current.dateComponents(
                [.day, .month, .year, .hour],
                from: notificationDate
            )

            // Setting up the Notification's Content
            let content = UNMutableNotificationContent()
            content.title = "SampleTitle"
            content.body = "SampleBody"
            content.sound = UNNotificationSound.default

            // Trigger's creation
            let trigger = UNCalendarNotificationTrigger(dateMatching: firstNotificationDateComponents, repeats: false)

            // ID
            let id = UUID().uuidString

            // Notification is fully constructed with the Request
            let request = UNNotificationRequest(
                identifier: id,
                content: content,
                trigger: trigger
            )

            await #expect(throws: Never.self) {
                try await sut.notificationHelper.center.add(request)
            }
        }
    }

    private func areNotificationsInChronologicalOrder(_ requests: [UNNotificationRequest]) -> Bool {
        // First, we extract the notifications's dates
        let dates = requests.compactMap { request -> Date? in
            if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                return trigger.nextTriggerDate()
            }
            return nil
        }

        return zip(dates, dates.dropFirst()).allSatisfy { $0 <= $1 }
    }

    private func getLastDayFromDatePickerMode() -> Date? {
        let dates = sut.multiDatePickerDateSet.compactMap { $0.date }

        if let lastDate = dates.sorted(by: <).last {
            let startOfLastDate = Calendar.current.startOfDay(for: lastDate)

            guard let fullLastDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfLastDate) else {
                Issue.record("LastDay should be correct.")
                return nil
            }

            return fullLastDate
        } else {
            Issue.record("Cannot get the last date from datePicker.")
            return nil
        }
    }

    @Test("When adding a medicine in \"datePicker mode\", if calculateLastDay() throw, medicine is not created.")
    func medicineNotAddedIfLastDayCannotBeCalculated() {
        sut.medicineName = "MedicineTest"
        sut.medicineDosage = "DosageTest"
        setupTakingTime()

        guard let _ = sut.createMedicineFlow() else {
            #expect(sut.showingAlert)
            #expect(sut.errorMessage == """
                Oups, une erreur est survenue ! Veuillez vérifier
                les jours sélectionnés, ou bien choisir \"Tous les jours\"
                """)
            return
        }

        Issue.record("The medicine creation flow should have failed.")
    }

    @Test("When adding a medicine in \"everyDay mode\" with its notifications properly, they should be added.")
    func addingMedicineInEverydayModeShouldWorkWhenGoodSetup() async {
        sut.medicineName = "MedicineTest"
        sut.medicineDosage = "DosageTest"
        sut.everyDay = true
        sut.duration = 2
        setupTakingTime()

        guard let medicine = sut.createMedicineFlow() else {
            Issue.record("The medicine creation flow failed.")
            return
        }

        #expect(!sut.showingAlert)
        #expect(sut.errorMessage.isEmpty)
        #expect(medicine.name == "MedicineTest")
        #expect(medicine.dosage == "DosageTest")
        #expect(medicine.medicineType == .pill)
        #expect(medicine.everyDay)
        #expect(medicine.takingTimes.count == 1)
        #expect(medicine.dates.count == 2)
        #expect(((medicine.additionalInformation?.isEmpty) != nil))

        guard let duration = sut.duration,
              let lastDay = Calendar.current.date(byAdding: .day, value: duration, to: sut.today) else {
            Issue.record("Cannot get lastDay, either duration property is nil or something unexpected happened.")
            return
        }

        #expect(medicine.lastDay == lastDay)
        #expect(medicine.timeZone == .current)
        #expect(medicine.notificationIDs == nil)

        // Notification part
        sut.userDefault.set(2, forKey: "badgeCount") // Should be 2 because we just added 2 notifications
        await setupSampleNotifications()
        await sut.scheduleNotificationsFlow(medicine: medicine, petName: "PetTestName")
        let notificationRequests = await sut.notificationHelper.center.pendingNotificationRequests()
        #expect(notificationRequests.count == 4)
        #expect(areNotificationsInChronologicalOrder(notificationRequests))
        #expect(sut.notificationIDs.count == 2)

        // UserDefault part
        #expect(sut.userDefault.value(forKey: "badgeCount") as? Int == 4)
    }

    @Test("When adding a medicine in \"datePicker mode\" and its notifications properly, they should be added.")
    func addingMedicineInDatePickerModeShouldWorkWhenGoodSetup() async {
        let today = Date.now
        sut.medicineName = "MedicineTest"
        sut.medicineDosage = "DosageTest"
        sut.multiDatePickerDateSet = setupDates(with: today)
        setupTakingTime()

        guard let medicine = sut.createMedicineFlow() else {
            Issue.record("The medicine creation flow failed.")
            return
        }

        #expect(!sut.showingAlert)
        #expect(sut.errorMessage.isEmpty)
        #expect(medicine.name == "MedicineTest")
        #expect(medicine.dosage == "DosageTest")
        #expect(medicine.medicineType == .pill)
        #expect(!medicine.everyDay)
        #expect(medicine.takingTimes.count == 1)
        #expect(medicine.dates.count == 2)
        #expect(((medicine.additionalInformation?.isEmpty) != nil))

        guard let lastDay = getLastDayFromDatePickerMode() else {
            Issue.record("LastDay should not be nil.")
            return
        }

        #expect(medicine.lastDay == lastDay)
        #expect(medicine.timeZone == .current)
        #expect(medicine.notificationIDs == nil)

        // Notification part
        await setupSampleNotifications()
        await sut.scheduleNotificationsFlow(medicine: medicine, petName: "PetTestName")
        let notificationRequests = await sut.notificationHelper.center.pendingNotificationRequests()
        #expect(notificationRequests.count == 4)
        #expect(areNotificationsInChronologicalOrder(notificationRequests))
        #expect(sut.notificationIDs.count == 2)

        // UserDefault part
        #expect(sut.userDefault.value(forKey: "badgeCount") as? Int == 4)
    }

    @Test("When adding a medicine with outdated dates, notifications should not be added.")
    func notificationsNotAddedIfDatesOutdated() async {
        guard let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date.now) else {
            Issue.record("Removing 1 year from today should not be nil.")
            return
        }

        sut.medicineName = "MedicineTest"
        sut.medicineDosage = "DosageTest"
        sut.multiDatePickerDateSet = setupDates(with: oneYearAgo)
        setupTakingTime()

        guard let medicine = sut.createMedicineFlow() else {
            Issue.record("The medicine creation flow failed.")
            return
        }

        await sut.scheduleNotificationsFlow(medicine: medicine, petName: "PetTestName")
        let notificationRequests = await sut.notificationHelper.center.pendingNotificationRequests()
        #expect(notificationRequests.count == 0)
    }

    @Test("When FocusedField is .name, nextField() should return .dosage FocusedField.")
    func nextFieldFunctionShouldReturnWithDosage() {
        let focusedField = AddMedicineView.FocusedField.name

        #expect(sut.nextField(focusedField: focusedField) == .dosage)
    }

    @Test("When FocusedField is .dosage, nextField() should return .additionalInformation FocusedField.")
    func nextFieldFunctionShouldReturnWithAdditionalInformation() {
        let focusedField = AddMedicineView.FocusedField.dosage

        #expect(sut.nextField(focusedField: focusedField) == .additionalInformation)
    }

    @MainActor
    @Test("When correct context, savePet should save correctly.")
    func savePetShouldSave() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer

        #expect(throws: Never.self) {
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)
            #expect(pet.information.name == "testName")

            pet.information.name = "ModifiedName"

            let didSave = sut.savePet(context: mockContainer.mainContext)
            #expect(didSave)

            // Now, let's make sure the changes propagate through persistent storage
            let newContext = ModelContext(mockContainer)
            let secondDescriptor = FetchDescriptor<Pet>()
            let savedPets = try newContext.fetch(secondDescriptor)

            #expect(savedPets.count == 1)
            #expect(savedPets[0].information.name == "ModifiedName")
        }
    }

    @MainActor
    @Test("When savePet() throws, savePet should throw.")
    func savePetShouldNotBeSavedIfItThrows() {
        // Let's first setup our pet and the mockContainer
        let pet = PetTest().pet
        let mockContainer = MockContainer().mockContainer
        mockSwiftDataHelper.saveShouldFail = true

        #expect(throws: Never.self) {
            try mockSwiftDataHelper.addPet(pet: pet, with: mockContainer.mainContext)

            #expect(pet.information.name == "testName")

            let didSave = sut.savePet(context: mockContainer.mainContext)
            #expect(!didSave)
            #expect(self.sut.showingAlert)
            #expect(self.sut.errorMessage == """
            Oups, la sauvegarde ne s'est pas passée comme prévue, essayez de redémarrer l'application.
            """)
        }
    }
}
