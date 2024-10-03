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
            VStack(alignment: .leading, spacing: 30) {
                IdentificationView()
                FavoriteView()
            }
            .navigationBarBackButtonHidden(true)
            .customBackButtonToolBar(with: "Profil", dismiss: { dismiss() })
            .navigationTitle("Informations")
            .navigationBarTitleDisplayMode(.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding([.top, .leading, .trailing])
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingEditInformationView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .font(.title)
                    .buttonLinearGradient(for: .foreground)
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
            CategoryGrayTitleView(text: "Identification", systemImage: "cpu", foregroundStyle: .white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradient.linearBlue)

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
            .padding([.leading, .bottom])
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(UIColor.systemBackground))
        .foregroundStyle(Color(UIColor.label))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .blue, radius: 10)
    }
}

struct FavoriteView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CategoryGrayTitleView(text: "Favoris", systemImage: "star.fill", foregroundStyle: .white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradient.linearBlue)

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
            .padding([.leading, .bottom])
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(UIColor.systemBackground))
        .foregroundStyle(Color(UIColor.label))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .blue, radius: 10)
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
