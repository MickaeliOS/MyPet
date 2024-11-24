//
//  VeterinarianView.swift
//  MyPet
//
//  Created by Mickaël Horn on 02/09/2024.
//

import SwiftUI

struct VeterinarianView: View {

    // MARK: PROPERTY
    @Environment(Pet.self) private var pet
    @State private var isPresentingEditVeterinarianView = false

    // MARK: BODY
    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            VStack(alignment: .leading) {
                Text("Nom")
                    .bold()
                Text((pet.veterinarian?.name).orDefault())
                    .padding(.bottom, 6)

                Text("Adresse")
                    .bold()
                Text((pet.veterinarian?.address).orDefault())
                    .padding(.bottom, 6)

                Text("Téléphone")
                    .bold()

                Text((pet.veterinarian?.phone).orDefault())
                    .padding(.bottom, 6)

                Text("Site web")
                    .bold()
                    .textInputAutocapitalization(.none)

                Text((pet.veterinarian?.website).orDefault())
            }
            .navigationTitle("Vétérinaire")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingEditVeterinarianView = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .font(.title2)
                }
            }
            .sheet(isPresented: $isPresentingEditVeterinarianView) {
                EditVeterinarianView()
            }
            .padding()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return TabView {
            NavigationStack {
                VeterinarianView()
            }
            .modelContainer(previewer.container)
            .environment(previewer.firstPet)
            .tabItem {
                Label(
                    PetTabView.Category.veterinarian.rawValue,
                    systemImage: PetTabView.Category.veterinarian.imageName
                )
            }
        }

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
