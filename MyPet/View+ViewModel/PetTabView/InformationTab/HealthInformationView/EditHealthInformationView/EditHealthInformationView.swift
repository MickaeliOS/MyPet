//
//  EditHealthInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import SwiftUI

struct EditHealthInformationView: View {

    // MARK: - PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.dismiss) private var dismiss

    @State private var isSterelizedChanged = false
    @State private var viewModel = ViewModel()

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Toggle("Stérilisé ?", isOn: $viewModel.isSterelized)
                        .onChange(of: viewModel.isSterelized) {
                            isSterelizedChanged = true
                        }
                        .padding()

                    EditListView(viewModel: .init(dataType: .allergy), list: $viewModel.allergies)
                    EditListView(viewModel: .init(dataType: .intolerance), list: $viewModel.intolerances)
                }
                .navigationTitle("Modif Infos. Medicales")
                .onAppear {
                    viewModel.setupHealthInformations(with: pet.health)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Sauvegarder") {
                            if pet.health == nil {
                                pet.health = Health()
                            }

                            if !viewModel.allergies.isEmpty {
                                viewModel.allergies = viewModel.allergies.removeEmptyElement()
                                pet.health?.allergies = viewModel.allergies
                            } else {
                                pet.health?.allergies = nil
                            }

                            if !viewModel.intolerances.isEmpty {
                                viewModel.intolerances = viewModel.intolerances.removeEmptyElement()
                                pet.health?.intolerances = viewModel.intolerances
                            } else {
                                pet.health?.intolerances = nil
                            }

                            if isSterelizedChanged { pet.health?.isSterelized = viewModel.isSterelized }

                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - PREVIEW
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
