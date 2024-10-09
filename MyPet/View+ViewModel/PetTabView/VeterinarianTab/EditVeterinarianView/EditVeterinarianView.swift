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
            VStack {
                TextField("Nom", text: $viewModel.name)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .customTextField(with: Image(systemName: "person"))

                TextField("Adresse", text: $viewModel.address)
                    .focused($focusedField, equals: .address)
                    .submitLabel(.next)
                    .customTextField(with: Image(systemName: "mappin.circle.fill"))

                TextField("Téléphone", value: $viewModel.phone, format: .number)
                    .focused($focusedField, equals: .phone)
                    .submitLabel(.next)
                    .keyboardType(.phonePad)
                    .customTextField(with: Image(systemName: "phone.fill"))

                TextField("Site web", text: $viewModel.website)
                    .focused($focusedField, equals: .website)
                    .submitLabel(.next)
                    .customTextField(with: Image(systemName: "globe"))
            }
            .navigationTitle("Modifier Vétérinaire")
            .padding()
            .frame(maxHeight: .infinity, alignment: .topLeading)
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
                    .disabled(viewModel.isFormValid)
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
    do {
        let previewer = try Previewer()

        return EditVeterinarianView()
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
