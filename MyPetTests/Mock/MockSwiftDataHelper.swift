//
//  MockSwiftDataHelper.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 28/11/2024.
//

import Foundation
import SwiftData
@testable import MyPet

final class MockSwiftDataHelper: SwiftDataProtocol {
    var saveShouldFail = false

    func save(with context: ModelContext) throws(MyPet.SwiftDataHelperError) {
        if saveShouldFail {
            throw .couldNotSave
        }

        do {
            try context.save()
        } catch {
            throw .couldNotSave
        }
    }

    func addPet(pet: Pet, with context: ModelContext) throws(MyPet.SwiftDataHelperError) {
        do {
            context.insert(pet)
            try context.save()
        } catch {
            throw .couldNotSave
        }
    }
}
