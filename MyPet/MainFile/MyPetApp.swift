//
//  MyPetApp.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/08/2024.
//

import SwiftUI
import SwiftData

@main
struct MyPetApp: App {
    @State var path = NavigationPath()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                PetListView(path: $path)
            }
        }
        .modelContainer(for: Pet.self)
    }
}
