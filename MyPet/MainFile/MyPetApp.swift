//
//  MyPetApp.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/08/2024.
//

import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            PetListView()
        }
        .modelContainer(for: [Pet.self])
    }
}
