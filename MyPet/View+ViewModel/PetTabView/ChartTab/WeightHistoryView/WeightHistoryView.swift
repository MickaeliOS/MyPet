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
                        .onDelete(perform: pet.deleteWeight)
                    }
                    .toolbar {
                        EditButton()
                            .environment(\.locale, .init(identifier: "fr"))
                    }
                } else {
                    EmptyListView(emptyListMessage: "Historique vide", messageFontSize: .title2)
                }
            }
            .navigationTitle("Historique de poids")
            .navigationBarTitleDisplayMode(.large)
        }
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
