//
//  InformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import SwiftUI

struct InformationView: View {
    @State private var isPresentingEditInformationView = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                IdentificationView()
                FavoriteView()
            }
            .navigationBarBackButtonHidden(true)
            .customBackButtonToolBar(with: "Profil", dismiss: { dismiss() })
            .navigationTitle("Informations")
            .navigationBarTitleDisplayMode(.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingEditInformationView = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .font(.title2)
                    .foregroundStyle(LinearGradient.linearBlue)
                }
            }
            .sheet(isPresented: $isPresentingEditInformationView) {
                EditInformationView()
            }
        }
    }
}

struct IdentificationView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CategoryTitleView(text: "Identification", systemImage: "cpu")
                .padding([.leading, .top])

            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text("Puce")
                        .bold()
                    Text(pet.identification?.chip.map { "\($0)" } ?? "Non renseigné")
                }
                .padding([.bottom, .top], 6)

                VStack(alignment: .leading) {
                    Text("Localisation Puce")
                        .bold()
                    Text((pet.identification?.chipLocation).orDefault())
                }
                .padding(.bottom, 6)

                VStack(alignment: .leading) {
                    Text("Tatouage")
                        .bold()
                    Text((pet.identification?.tatoo).orDefault())
                }
                .padding(.bottom, 6)

                VStack(alignment: .leading) {

                    Text("Localisation Tatouage")
                        .bold()
                    Text((pet.identification?.tatooLocation).orDefault())
                }
                .padding(.bottom, 6)

            }
            .padding(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct FavoriteView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CategoryTitleView(text: "Favoris", systemImage: "star.fill")
                .padding([.leading, .top])

            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Jouet")
                        .bold()
                    Text((pet.favorite?.toy).orDefault())
                }
                .padding([.top, .bottom], 6)

                VStack(alignment: .leading) {

                    Text("Nourriture")
                        .bold()
                    Text((pet.favorite?.food).orDefault())
                }
                .padding(.bottom, 6)

                VStack(alignment: .leading) {

                    Text("Endroit")
                        .bold()
                    Text((pet.favorite?.place).orDefault())
                }
                .padding(.bottom, 6)
            }
            .padding(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
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
