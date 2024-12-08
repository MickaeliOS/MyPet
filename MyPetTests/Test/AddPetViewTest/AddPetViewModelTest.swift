//
//  AddPetViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 17/11/2024.
//

import Testing
import SwiftData
@testable import MyPet

final class AddPetViewModelTest {
    private var mockSwiftDataHelper: MockSwiftDataHelper!
    private let sut: AddPetView.ViewModel!

    init() {
        self.mockSwiftDataHelper = MockSwiftDataHelper()
        self.sut = .init(swiftDataHelper: mockSwiftDataHelper)
    }

    private func setupSUT(
        name: String = "",
        race: String = "",
        type: String = "",
        color: String = "",
        eyeColor: String = ""
    ) {
        sut.name = name
        sut.race = race
        sut.type = type
        sut.color = color
        sut.eyeColor = eyeColor
    }

    @Test("With all the fields correctly filled, isFormValid should be true.")
    func formShouldBeValid() {
        sut.name = "Pet"
        sut.race = "Race"
        sut.type = "Type"
        sut.eyeColor = "EyeColor"
        sut.color = "Color"

        #expect(sut.isFormValid)
    }

    @Test("With some empty fileds, isFormValid should be false.")
    func formShouldNotBeValid() {
        sut.name = "Pet"
        sut.race = ""
        sut.type = "Type"
        sut.eyeColor = ""
        sut.color = "Color"

        #expect(!sut.isFormValid)
    }

    @Test("When FocusedField is .name, nextField() should return .type FocusedField.")
    func nextFieldFunctionShouldReturnWithType() {
        let focusedField = AddPetView.FocusedField.name

        #expect(sut.nextField(focusedField: focusedField) == .type)
    }

    @Test("When FocusedField is .type, nextField() should return .race FocusedField.")
    func nextFieldFunctionShouldReturnWithRace() {
        let focusedField = AddPetView.FocusedField.type

        #expect(sut.nextField(focusedField: focusedField) == .race)
    }

    @Test("When FocusedField is .race, nextField() should return .color FocusedField.")
    func nextFieldFunctionShouldReturnWithColor() {
        let focusedField = AddPetView.FocusedField.race

        #expect(sut.nextField(focusedField: focusedField) == .color)
    }

    @Test("When FocusedField is .color, nextField() should return .eyeColor FocusedField.")
    func nextFieldFunctionShouldReturnWithEyeColor() {
        let focusedField = AddPetView.FocusedField.color

        #expect(sut.nextField(focusedField: focusedField) == .eyeColor)
    }

    @Test("When FocusedField is .eyeColor, nextField() should return .name FocusedField.")
    func nextFieldFunctionShouldReturnWithName() {
        let focusedField = AddPetView.FocusedField.eyeColor

        #expect(sut.nextField(focusedField: focusedField) == .name)
    }

    @MainActor @Test("When adding a Pet correctly, the pet should be added in container.")
    func addingPetShouldBeSuccessful() {
        let mockContainer = MockContainer().mockContainer

        setupSUT(name: "testName", race: "testRace", type: "testType", color: "testColor", eyeColor: "testEyeColor")

        #expect(sut.addPet(modelContext: mockContainer.mainContext))

        do {
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)

            #expect(pets.count == 1)

            let petInfos = pets[0].information
            #expect(petInfos.name == sut.name)
            #expect(petInfos.gender == sut.gender)
            #expect(petInfos.type == sut.type)
            #expect(petInfos.race == sut.race)
            #expect(petInfos.birthdate == sut.birthdate)
            #expect(petInfos.color == sut.color)
            #expect(petInfos.eyeColor == sut.eyeColor)
        } catch {
            Issue.record("MainContext fetch failed.")
        }
    }

    @MainActor @Test("When adding a Pet without a name, the pet should not be added.")
    func addingPetWithoutNameShouldFail() {
        let mockContainer = MockContainer().mockContainer
        setupSUT(race: "testRace", type: "typeTest", color: "colorTest", eyeColor: "eyeColorTest")

        #expect(sut.addPet(modelContext: mockContainer.mainContext) == false)
        #expect(sut.errorMessage == "Veuillez vérifier que tous les champs sont correctement remplis.")
        #expect(sut.showingAlert)

        do {
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)

            #expect(pets.count == 0)
        } catch {
            Issue.record("MainContext fetch failed.")
        }
    }

    @MainActor @Test("When adding a Pet without a race, the pet should not be added.")
    func addingPetWithoutRaceShouldFail() {
        let mockContainer = MockContainer().mockContainer
        setupSUT(name: "nameTest", type: "typeTest", color: "colorTest", eyeColor: "eyeColorTest")

        #expect(sut.addPet(modelContext: mockContainer.mainContext) == false)
        #expect(sut.errorMessage == "Veuillez vérifier que tous les champs sont correctement remplis.")
        #expect(sut.showingAlert)

        do {
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)

            #expect(pets.count == 0)
        } catch {
            Issue.record("MainContext fetch failed.")
        }
    }

    @MainActor @Test("When adding a Pet without a type, the pet should not be added.")
    func addingPetWithoutTypeShouldFail() {
        let mockContainer = MockContainer().mockContainer
        setupSUT(name: "nameTest", race: "raceTest", color: "colorTest", eyeColor: "eyeColorTest")

        #expect(sut.addPet(modelContext: mockContainer.mainContext) == false)
        #expect(sut.errorMessage == "Veuillez vérifier que tous les champs sont correctement remplis.")
        #expect(sut.showingAlert)

        do {
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)

            #expect(pets.count == 0)
        } catch {
            Issue.record("MainContext fetch failed.")
        }
    }

    @MainActor @Test("When adding a Pet without a color, the pet should not be added.")
    func addingPetWithoutColorShouldFail() {
        let mockContainer = MockContainer().mockContainer
        setupSUT(name: "nameTest", race: "raceTest", type: "typeColor", eyeColor: "eyeColorTest")

        #expect(sut.addPet(modelContext: mockContainer.mainContext) == false)
        #expect(sut.errorMessage == "Veuillez vérifier que tous les champs sont correctement remplis.")
        #expect(sut.showingAlert)

        do {
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)

            #expect(pets.count == 0)
        } catch {
            Issue.record("MainContext fetch failed.")
        }
    }

    @MainActor @Test("When adding a Pet without an eyeColor, the pet should not be added.")
    func addingPetWithoutEyeColorShouldFail() {
        let mockContainer = MockContainer().mockContainer
        setupSUT(name: "nameTest", race: "raceTest", type: "typeColor", color: "colorTest")

        #expect(sut.addPet(modelContext: mockContainer.mainContext) == false)
        #expect(sut.errorMessage == "Veuillez vérifier que tous les champs sont correctement remplis.")
        #expect(sut.showingAlert)

        do {
            let descriptor = FetchDescriptor<Pet>()
            let pets = try mockContainer.mainContext.fetch(descriptor)

            #expect(pets.count == 0)
        } catch {
            Issue.record("MainContext fetch failed.")
        }
    }

    @MainActor @Test("When adding a Pet trigger a context save error, addPet() method should throw.")
    func addPetMethodShouldThrowWhenContextSaveError() {
        let mockContainer = MockContainer().mockContainer
        mockSwiftDataHelper.saveShouldFail = true

        setupSUT(name: "testName", race: "raceTest", type: "typeTest", color: "colorTest", eyeColor: "eyeColorTest")

        #expect(sut.addPet(modelContext: mockContainer.mainContext) == false)
        #expect(sut.errorMessage == """
                Oups, la sauvegarde ne s'est pas passée comme prévue, essayez de redémarrer l'application.
                """
        )
        #expect(sut.showingAlert)
        #expect(mockContainer.mainContext.hasChanges == false)
    }
}
