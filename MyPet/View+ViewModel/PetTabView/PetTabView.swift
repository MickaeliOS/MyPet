//
//  PetTabView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import SwiftUI

struct PetTabView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        TabView {
            InformationView()
                .tabItem {
                    Label("Infos", systemImage: "info.circle.fill")
                }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            PetTabView()
                .environment(previewer.firstPet)
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
