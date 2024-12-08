//
//  EditListViewModelTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 08/12/2024.
//

import Foundation
import Testing
@testable import MyPet

struct EditListViewModelTest {
    @Test("If dataType is Allergy, correct image should be returned")
    func correctImageReturnedIfAllergy() {
        let sut = EditListView.ViewModel(dataType: .allergy)
        #expect(sut.dataType.imageName == "allergens.fill")
    }

    @Test("If dataType is Intolerance, correct image should be returned")
    func correctImageReturnedIfIntolerance() {
        let sut = EditListView.ViewModel(dataType: .intolerance)
        #expect(sut.dataType.imageName == "exclamationmark.octagon.fill")
    }
}
