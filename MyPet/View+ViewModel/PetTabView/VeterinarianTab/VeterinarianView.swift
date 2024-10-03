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
                    .padding(.bottom)

                Text("Adresse")
                    .bold()
                Text(viewModel.orDefault(pet.veterinarian?.address))
                    .padding(.bottom)

                Text("Téléphone")
                    .bold()

                Text(viewModel.orDefault(pet.veterinarian?.phone.map { "\($0)" }))
                    .padding(.bottom)

                Text("Site web")
                    .bold()
                    .textInputAutocapitalization(.none)

                Text(viewModel.orDefault(pet.veterinarian?.website))                    .padding(.bottom)
            }
            .navigationTitle("Vétérinaire")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    OpenModalButton(
                        isPresentingView: $isPresentingEditVeterinarianView,
                        content: EditVeterinarianView(),
                        systemImage: "pencil.line"
                    )
                }
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
