//
//  EditHealthInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 12/09/2024.
//

import SwiftUI

struct EditHealthInformationView: View {

    // MARK: PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ViewModel()

    // MARK: BODY
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Toggle("Stérilisé ?", isOn: $viewModel.isSterelized)
                        .onChange(of: viewModel.isSterelized) {
                            viewModel.isSterelizedChanged = true
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
                            if viewModel.savePet(pet: pet, context: modelContext) {
                                dismiss()
                            }
                        }
                    }
                }
                .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
                    Button("OK") { }
                } message: {
                    Text(viewModel.errorMessage)
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
                .modelContainer(previewer.container)
                .environment(previewer.firstPet)
        }

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
