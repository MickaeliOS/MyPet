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
            CategoryGrayTitleView(text: "Infos", systemImage: "cross.case.fill")

            if let isSterelized = pet.health?.isSterelized {
                Text("Stérélisé : \(isSterelized ? "Oui" : "Non")")
                    .padding()
            } else {
                Text("Stérélisé : Non renseigné.")
                    .padding()
            }

            AllergyView(allergies: pet.health?.allergies)
            IntoleranceView(intolerance: pet.health?.intolerances)
        }
        .navigationTitle("Infos. Médicales")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding([.top])
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                OpenModalButton(
                    isPresentingView: $showEditHealthInformations,
                    content: EditHealthInformationView(),
                    systemImage: "pencil.line"
                )
            }
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
struct AllergyView: View {
    let allergies: [String]?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                CategoryGrayTitleView(text: "Allergies", systemImage: "allergens.fill")
                Spacer()
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
    }
}

struct IntoleranceView: View {
    let intolerance: [String]?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                CategoryGrayTitleView(text: "Intolérances", systemImage: "exclamationmark.octagon.fill")
                Spacer()
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
    }
}
