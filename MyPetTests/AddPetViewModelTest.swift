////
////  AddPetViewModelTest.swift
////  MyPetTests
////
////  Created by Mickaël Horn on 17/11/2024.
////
//
//import Testing
//@testable import MyPet
//
//@Suite
//struct AddPetViewModelTest {
//    private let sut = AddPetView.ViewModel()
//
//    @Test("With all the fields correctly filled, isFormValid should be true.")
//    func formShouldBeValid() {
//        sut.name = "Pet"
//        sut.race = "Race"
//        sut.type = "Type"
//        sut.eyeColor = "EyeColor"
//        sut.color = "Color"
//
//        #expect(sut.isFormValid)
//    }
//
//    @Test("With some empty fileds, isFormValid should be false.")
//    func formShouldNotBeValid() {
//        sut.name = "Pet"
//        sut.race = ""
//        sut.type = "Type"
//        sut.eyeColor = ""
//        sut.color = "Color"
//
//        #expect(!sut.isFormValid)
//    }
//
//    @Test("When FocusedField is .name, nextField() should return .type FocusedField.")
//    func nextFieldFunctionShouldReturnWithType() {
//        let focusedField = AddPetView.FocusedField.name
//
//        #expect(sut.nextField(focusedField: focusedField) == .type)
//    }
//
//    @Test("When FocusedField is .type, nextField() should return .race FocusedField.")
//    func nextFieldFunctionShouldReturnWithRace() {
//        let focusedField = AddPetView.FocusedField.type
//
//        #expect(sut.nextField(focusedField: focusedField) == .race)
//    }
//
//    @Test("When FocusedField is .race, nextField() should return .color FocusedField.")
//    func nextFieldFunctionShouldReturnWithColor() {
//        let focusedField = AddPetView.FocusedField.race
//
//        #expect(sut.nextField(focusedField: focusedField) == .color)
//    }
//
//    @Test("When FocusedField is .color, nextField() should return .eyeColor FocusedField.")
//    func nextFieldFunctionShouldReturnWithEyeColor() {
//        let focusedField = AddPetView.FocusedField.color
//
//        #expect(sut.nextField(focusedField: focusedField) == .eyeColor)
//    }
//
//    @Test("When a ")
//}
