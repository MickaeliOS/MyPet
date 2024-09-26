//
//  InformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import SwiftUI

struct InformationView: View {
    @State private var isPresentingEditInformationView = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            IdentificationView()
            FavoriteView()
        }
        .navigationTitle("Informations")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding([.top, .leading, .trailing])
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                OpenModalButton(
                    isPresentingView: $isPresentingEditInformationView,
                    content: EditInformationView(),
                    systemImage: "pencil.line"
                )
            }
        }
    }
}

struct IdentificationView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CategoryGrayTitleView(text: "Identification", systemImage: "cpu")

            Text("Puce")
                .bold()
            Text(pet.identification?.chip.map { "\($0)" } ?? "Non renseigné")

            Text("Localisation Puce")
                .bold()
            Text((pet.identification?.chipLocation).orDefault())

            Text("Tatouage")
                .bold()
            Text((pet.identification?.tatoo).orDefault())

            Text("Localisation Tatouage")
                .bold()
            Text((pet.identification?.tatooLocation).orDefault())
        }
    }
}

struct FavoriteView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CategoryGrayTitleView(text: "Favoris", systemImage: "star.fill")

            Text("Jouet")
                .bold()
            Text((pet.favorite?.toy).orDefault())

            Text("Nourriture")
                .bold()
            Text((pet.favorite?.food).orDefault())

            Text("Endroit")
                .bold()
            Text((pet.favorite?.place).orDefault())
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            InformationView()
                .environment(try? Previewer().firstPet)
        }
    }
}
