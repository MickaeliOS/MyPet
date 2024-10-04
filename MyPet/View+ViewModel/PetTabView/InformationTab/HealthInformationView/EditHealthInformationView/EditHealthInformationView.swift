//
//  EditHealthInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import SwiftUI

struct EditHealthInformationView: View {
    @Environment(Pet.self) var pet
    @Environment(\.dismiss) var dismiss

    @State private var allergies: [String] = []
    @State private var intolerances: [String] = []
    @State private var isSterelized = false
    @State private var isSterelizedChanged = false
    @State private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Toggle("Stérélisé ?", isOn: $isSterelized)
                    .onChange(of: isSterelized) {
                        isSterelizedChanged = true
                    }
                    .padding()

                EditListView(list: $allergies, viewModel: .init(dataType: .allergy))
                EditListView(list: $intolerances, viewModel: .init(dataType: .intolerance))
            }
            .navigationTitle("Modif Infos. Medicales")
            .onAppear {
                if let health = pet.health {
                    allergies = health.allergies ?? []
                    intolerances = health.intolerances ?? []

                    if let isSterelized = health.isSterelized {
                        self.isSterelized = isSterelized
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sauvegarder") {
                        if pet.health == nil {
                            pet.health = Health()
                        }

                        pet.health?.allergies = viewModel.isListValid(allergies) ? allergies : nil
                        pet.health?.intolerances = viewModel.isListValid(intolerances) ? intolerances : nil
                        if isSterelizedChanged { pet.health?.isSterelized = isSterelized }

                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            EditHealthInformationView()
                .environment(previewer.firstPet)
        }

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
