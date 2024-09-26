//
//  EditListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 04/09/2024.
//

import SwiftUI

struct EditListView: View {
    @Environment(Pet.self) var pet
    @Environment(\.dismiss) var dismiss

    @State private var dataType = DataType.allergy
    @State var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            VStack {
                ForEach(viewModel.elements.indices, id: \.self) { index in

                    // Minus Button + Allergy TextField
                    HStack {
                        Button {
                            if viewModel.elements.indices.contains(index) {
                                viewModel.elements.remove(at: index)
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                        }

                        if viewModel.elements.indices.contains(index) {
                            TextField("Allergie \(index + 1)", text: $viewModel.elements[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 4)
                        }
                    }
                }

                // Create a new TextField
                Button {
                    viewModel.elements.append("")
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter une allergie")
                    }
                    .font(.title3)
                }
            }
            .padding()
            .onAppear {
                viewModel.elements = pet.health?.allergies ?? []
            }
            .navigationTitle("Ajouter des allergies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sauvegarder") {
                        pet.health?.allergies = viewModel.elements
                        dismiss()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return EditListView(viewModel: EditListView.ViewModel(dataType: .allergy))
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
