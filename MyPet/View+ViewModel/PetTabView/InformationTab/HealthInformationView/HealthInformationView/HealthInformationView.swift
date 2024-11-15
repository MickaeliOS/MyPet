//
//  HealthInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import SwiftUI

struct HealthInformationView: View {
    @Environment(Pet.self) private var pet
    @State private var showEditHealthInformations = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                SterelizedView()
                AllergyView(allergies: pet.health?.allergies)
                IntoleranceView(intolerances: pet.health?.intolerances)
            }
            .navigationTitle("Infos. Médicales")
            .navigationBarTitleDisplayMode(.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showEditHealthInformations = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .font(.title2)
                }
            }
            .sheet(isPresented: $showEditHealthInformations) {
                EditHealthInformationView()
            }
        }
    }
}

// MARK: - CHILD VIEW
struct SterelizedView: View {
    @Environment(Pet.self) private var pet

    var body: some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Infos", systemImage: "cross.case.fill")

            Text("Stérilisation")
                .bold()
                .padding(.top, 6)

            if let isSterelized = pet.health?.isSterelized {
                Text("\(isSterelized ? "Oui" : "Non")")
            } else {
                Text("Non renseigné")
            }
        }
    }
}

struct AllergyView: View {
    let allergies: [String]?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                CategoryTitleView(text: "Allergies", systemImage: "allergens.fill")
            }

            if let allergies, !allergies.isEmpty {
                Text("number: \(allergies.count)")
                Text(allergies.joined(separator: ", "))
                    .padding([.top, .bottom])
            } else {
                EmptyListView(
                    emptyListMessage: """
                    La liste est vide, appuyez sur le petit stylo en haut à droite.
                    """,
                    messageFontSize: .title3,
                    orientation: .horizontal
                )
            }
        }
    }
}

struct IntoleranceView: View {
    let intolerances: [String]?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                CategoryTitleView(text: "Intolérances", systemImage: "exclamationmark.octagon.fill")
            }

            if let intolerances, !intolerances.isEmpty {
                Text("number: \(intolerances.count)")

                Text(intolerances.joined(separator: ", "))
                    .padding([.top, .bottom])
            } else {
                EmptyListView(
                    emptyListMessage: """
                    La liste est vide, appuyez sur le petit stylo en haut à droite.
                    """,
                    messageFontSize: .title3,
                    orientation: .horizontal
                )
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return TabView {
            NavigationStack {
                HealthInformationView()
            }
            .tabItem {
                Label(
                    PetTabView.Category.infos.rawValue,
                    systemImage: PetTabView.Category.infos.imageName
                )
            }
            .environment(previewer.firstPet)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
