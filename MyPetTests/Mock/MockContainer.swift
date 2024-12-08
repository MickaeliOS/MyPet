//
//  MockContainer.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 17/11/2024.
//

import Foundation
import SwiftData
import Testing
@testable import MyPet

struct MockContainer {
    let mockContainer: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: Pet.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )

            return container
        } catch {
            fatalError("Mock Container failed.")
        }
    }()
}
