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
    @State var selectedPet: Pet?

    var body: some Scene {
        WindowGroup {
            Group {
                if selectedPet != nil {
                    PetTabView(selectedPet: $selectedPet)
                        .transition(.move(edge: .trailing))
                } else {
                    PetListView(selectedPet: $selectedPet)
                        .transition(.move(edge: .leading))
                }
            }
        }
        .modelContainer(for: [Pet.self])
    }
}
