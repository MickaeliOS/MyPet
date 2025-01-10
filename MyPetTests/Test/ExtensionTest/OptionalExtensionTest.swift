//
//  OptionalExtensionTest.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 09/01/2025.
//

import Foundation
import Testing
@testable import MyPet

final class OptionalExtensionTest {
    @Test("orDefault() returns \"Non renseigné\" if nil.")
    func orDefaultMethodWorksWhenNil() {
        let optionalString: String? = nil
        #expect(optionalString.orDefault() == "Non renseigné")
    }

    @Test("orDefault() returns wrappedValue if non nil.")
    func orDefaultMethodReturnsWrappedValue() {
        let optionalString: String? = "Hello"
        #expect(optionalString.orDefault() == "Hello")
    }
}
