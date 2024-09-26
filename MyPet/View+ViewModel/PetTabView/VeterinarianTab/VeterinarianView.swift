//
//  VeterinarianView.swift
//  MyPet
//
//  Created by Mickaël Horn on 02/09/2024.
//

import SwiftUI

struct VeterinarianView: View {
    @Environment(Pet.self) var pet
    private let viewModel = ViewModel()

    var body: some View {
        VStack {
            CategoryGrayTitleView(text: "Vétérinaire", systemImage: "cross.case.fill")

            Text("Nom")
                .bold()
            Text(viewModel.orDefault(pet.veterinarian?.name))

            Text("Adresse")
                .bold()
            Text(viewModel.orDefault(pet.veterinarian?.address))

            Text("Téléphone")
                .bold()
            Text(pet.veterinarian?.phone != nil ? "\(pet.veterinarian!.phone)" : "Non renseigné")

            Text("Site web")
                .bold()
            Text(viewModel.orDefault(pet.veterinarian?.website))
        }
    }
}

#Preview {
    VeterinarianView()
        .environment(try? Previewer().firstPet)
}
