//
//  EditVeterinarianView.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import SwiftUI

struct EditVeterinarianView: View {

    // MARK: - PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.dismiss) private var dismiss

    @FocusState private var focusedField: FocusedField?
    @State private var viewModel = ViewModel()

    // MARK: - BODY
    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            ZStack {
                HideKeyboardView()

                VStack {
                    TextField("Nom", text: ($pet.veterinarian ?? viewModel.sampleVeterinarian).name ?? "")
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .customTextField(with: Image(systemName: "person"))

                    TextField("Adresse", text: ($pet.veterinarian ?? viewModel.sampleVeterinarian).address ?? "")
                        .focused($focusedField, equals: .address)
                        .submitLabel(.next)
                        .customTextField(with: Image(systemName: "mappin.circle.fill"))

                    TextField("Téléphone", text: ($pet.veterinarian ?? viewModel.sampleVeterinarian).phone ?? "")
                        .focused($focusedField, equals: .phone)
                        .submitLabel(.next)
                        .keyboardType(.phonePad)
                        .customTextField(with: Image(systemName: "phone.fill"))

                    TextField("Site web", text: ($pet.veterinarian ?? viewModel.sampleVeterinarian).website ?? "")
                        .focused($focusedField, equals: .website)
                        .submitLabel(.done)
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

        return EditVeterinarianView()
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
