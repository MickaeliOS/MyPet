//
//  InformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import SwiftUI

// MARK: - MAIN VIEW
struct InformationView: View {
    @State private var isPresentingEditInformationView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                IdentificationView()
                FavoriteView()
            }
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
                    .foregroundStyle(.blue)
                }
            }
            .sheet(isPresented: $isPresentingEditInformationView) {
                EditInformationView()
            }
        }
    }
}

// MARK: - CHILD VIEW
struct IdentificationView: View {
    @Environment(Pet.self) private var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CategoryTitleView(text: "Identification", systemImage: "cpu")
                .padding([.leading, .top])

            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text("Puce")
                        .bold()
                    Text((pet.identification?.chip).orDefault())
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
    @Environment(Pet.self) private var pet

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

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return TabView {
            NavigationStack {
                InformationView()
            }
        }
        .modelContainer(previewer.container)
        .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
