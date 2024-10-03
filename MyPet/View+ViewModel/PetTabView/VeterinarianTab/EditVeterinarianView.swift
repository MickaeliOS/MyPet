//
//  EditVeterinarianView.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import SwiftUI

struct EditVeterinarianView: View {
    @State private var viewModel = ViewModel()
    @FocusState private var focusedField: FocusedField?
    @Environment(Pet.self) var pet
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nom", text: $viewModel.name)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)

                TextField("Adresse", text: $viewModel.address)
                    .focused($focusedField, equals: .address)
                    .submitLabel(.next)

                TextField("Téléphone", value: $viewModel.phone, format: .number)
                    .focused($focusedField, equals: .phone)
                    .submitLabel(.next)
                    .keyboardType(.phonePad)

                TextField("Site web", text: $viewModel.website)
                    .focused($focusedField, equals: .website)
                    .submitLabel(.next)
            }
            .navigationTitle("Modifier Vétérinaire")
            .onSubmit {
                focusedField = viewModel.nextField(focusedField: focusedField ?? .name)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if focusedField == .phone {
                        Spacer()
                        Button("Suivant") {
                            focusedField = viewModel.nextField(focusedField: focusedField ?? .name)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sauvegarder") {
                        addVeterinarian()
                        dismiss()
                    }
                }
            }
        }
    }

    private func addVeterinarian() {
        pet.veterinarian = Veterinarian(
            name: viewModel.name,
            address: viewModel.address,
            phone: viewModel.phone ?? nil,
            website: viewModel.website
        )
    }
}

#Preview {
    EditVeterinarianView()
}
