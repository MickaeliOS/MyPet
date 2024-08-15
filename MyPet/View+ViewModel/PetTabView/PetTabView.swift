//
//  PetTabView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import SwiftUI

struct PetTabView: View {
    @Binding var selectedPet: Pet?

    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        selectedPet = nil
                    }
                } label: {
                    Label("Mes animaux", systemImage: "chevron.left")
                        .font(.title3)
                }

                Spacer()
            }

            if let pet = selectedPet {
                TabView {
                    InformationView()
                        .tabItem {
                            Label("Infos", systemImage: "info.circle.fill")
                        }
                }
                .environment(pet)
            }
        }
        .padding()
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            PetTabView(selectedPet: .constant(previewer.firstPet))
                .environment(previewer.firstPet)
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
