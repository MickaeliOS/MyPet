//
//  HealthInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import SwiftUI

struct HealthInformationView: View {
    @Environment(Pet.self) var pet

    @State private var showEditHealthInformations = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SterelizedView()
            AllergyView(allergies: pet.health?.allergies)
            IntoleranceView(intolerance: pet.health?.intolerances)
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
            }
        }
        .sheet(isPresented: $showEditHealthInformations) {
            EditHealthInformationView()
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            HealthInformationView()
                .environment(previewer.firstPet)
        }

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

// MARK: - CHILD VIEWS
struct SterelizedView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Infos", systemImage: "cross.case.fill", foregroundStyle: .white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradient.linearBlue)

            if let isSterelized = pet.health?.isSterelized {
                Text("Stérélisé : \(isSterelized ? "Oui" : "Non")")
                    .padding()
            } else {
                Text("Stérélisé : Non renseigné.")
                    .padding()
            }
        }
        .background(Color(UIColor.systemBackground))
        .foregroundStyle(Color(UIColor.label))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .blue, radius: 10)
    }
}

struct AllergyView: View {
    let allergies: [String]?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                CategoryTitleView(
                    text: "Allergies",
                    systemImage: "allergens.fill",
                    foregroundStyle: .white
                )
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradient.linearBlue)
            }

            if let allergies {
                Text(allergies.joined(separator: ", "))
                    .padding()
            } else {
                EmptyListView(
                    emptyListMessage: """
                    La liste est vide, appuyez sur la petite icône située à droite.
                    """,
                    messageFontSize: .title3
                )
            }
        }
        .background(Color(UIColor.systemBackground))
        .foregroundStyle(Color(UIColor.label))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .blue, radius: 10)
    }
}

struct IntoleranceView: View {
    let intolerance: [String]?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                CategoryTitleView(
                    text: "Intolérances",
                    systemImage: "exclamationmark.octagon.fill",
                    foregroundStyle: .white
                )
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradient.linearBlue)
            }

            if let intolerance {
                Text(intolerance.joined(separator: ", "))
                    .padding()
            } else {
                EmptyListView(
                    emptyListMessage: """
                    La liste est vide, appuyez sur la petite icône située à droite.
                    """,
                    messageFontSize: .title3
                )
            }
        }
        .background(Color(UIColor.systemBackground))
        .foregroundStyle(Color(UIColor.label))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .blue, radius: 10)
    }
}
