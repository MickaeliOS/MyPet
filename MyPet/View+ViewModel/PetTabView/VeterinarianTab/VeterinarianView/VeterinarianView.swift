//
//  VeterinarianView.swift
//  MyPet
//
//  Created by Mickaël Horn on 02/09/2024.
//

import SwiftUI

struct VeterinarianView: View {
    @Environment(Pet.self) var pet
    @State private var isPresentingEditVeterinarianView = false
    private let viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Nom")
                    .bold()
                Text(viewModel.orDefault(pet.veterinarian?.name))
                    .padding(.bottom, 6)

                Text("Adresse")
                    .bold()
                Text(viewModel.orDefault(pet.veterinarian?.address))
                    .padding(.bottom, 6)

                Text("Téléphone")
                    .bold()

                Text(viewModel.orDefault(pet.veterinarian?.phone.map { "\($0)" }))
                    .padding(.bottom, 6)

                Text("Site web")
                    .bold()
                    .textInputAutocapitalization(.none)

                Text(viewModel.orDefault(pet.veterinarian?.website))
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

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            VeterinarianView()
        }
        .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
