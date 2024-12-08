//
//  WeightHistoryView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/10/2024.
//

import SwiftUI

struct WeightHistoryView: View {

    // MARK: PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = ViewModel()

    // MARK: BODY
    var body: some View {
        NavigationStack {
            Group {
                if let weights = pet.weights, !weights.isEmpty {
                    List {
                        ForEach(weights) { weight in
                            HStack {
                                Text(weight.day, format: .dateTime.day().month().year())
                                Spacer()
                                Text("\(weight.weight.formatted()) Kg")
                            }
                        }
                        .onDelete(perform: deleteWeight)
                    }
                    .toolbar {
                        EditButton()
                            .environment(\.locale, .init(identifier: Locale.preferredLanguages[0]))
                    }
                } else {
                    EmptyListView(emptyListMessage: "Historique vide", messageFontSize: .title2)
                }
            }
            .navigationTitle("Historique de poids")
            .navigationBarTitleDisplayMode(.large)
            .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }

    private func deleteWeight(at offsets: IndexSet) {
        viewModel.deleteWeight(pet: pet, offsets: offsets, context: modelContext)
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            WeightHistoryView()
                .modelContainer(previewer.container)
                .environment(previewer.firstPet)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
