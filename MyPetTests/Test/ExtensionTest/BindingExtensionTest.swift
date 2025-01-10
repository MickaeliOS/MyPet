//
//  BindingExtensionTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 08/01/2025.
//

import Foundation
import Testing
@testable import MyPet
import SwiftUI

final class BindingExtensionTest {
    @Test("Optional overload operator works correctly")
    func optionalOverloadOperatorWorks() {
        var value: Int?

        let binding = Binding<Int?> {
            value
        } set: { newValue in
            value = newValue
        }

        let defaultValue = 10

        let resultBinding = binding ?? defaultValue

        // Since value is nil, we should get 10
        #expect(resultBinding.wrappedValue == defaultValue)

        value = 20
        #expect(resultBinding.wrappedValue == 20)

        value = nil
        #expect(resultBinding.wrappedValue == defaultValue)

        // set test
        resultBinding.wrappedValue = 30
        #expect(binding.wrappedValue == 30)
    }
}
