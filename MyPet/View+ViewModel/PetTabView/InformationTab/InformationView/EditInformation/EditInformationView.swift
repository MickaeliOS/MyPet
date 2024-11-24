//
//  EditInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 22/08/2024.
//

import SwiftUI

struct EditInformationView: View {

    // MARK: PROPERTY
    @Environment(\.modelContext) private var modelContext
    @Environment(Pet.self) private var pet
    @Environment(\.dismiss) private var dismiss
    @Environment(\.undoManager) private var undoManager

    @FocusState private var focusedField: FocusedField?

    @State private var viewModel = ViewModel()

    // MARK: BODY
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    HideKeyboardView()

                    VStack(alignment: .leading) {
                        identificationView()
                        favoriteView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding([.leading, .trailing])
                }
            }
            .onSubmit {
                if focusedField != .place {
                    focusedField = viewModel.nextField(focusedField: focusedField ?? .name)
                }
            }
            .navigationTitle("Modifier l'animal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sauvegarder") {
                        if viewModel.savePet(pet: pet, context: modelContext, undoManager: undoManager) {
                            dismiss()
                        }
                    }
                }
            }
            .onAppear {
                viewModel.identification = pet.identification
                viewModel.favorite = pet.favorite
            }
            .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }

    // MARK: VIEWBUILDER
    @ViewBuilder private func identificationView() -> some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Identification", systemImage: "cpu.fill")

            TextField(
                "Puce",
                text: ($viewModel.identification ?? viewModel.sampleIdentification).chip ?? ""
            )
            .customTextField(with: Image(systemName: "cpu.fill"))
            .focused($focusedField, equals: .chip)
            .keyboardType(.numberPad)
            .toolbar {
                if focusedField == .chip {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Suivant") {
                            focusedField = FocusedField.chipLocation
                        }
                    }
                }
            }

            TextField(
                "Localisation Puce",
                text: ($viewModel.identification ?? viewModel.sampleIdentification).chipLocation ?? ""
            )
            .customTextField(with: Image(systemName: "mappin.circle.fill"))
            .submitLabel(.next)
            .focused($focusedField, equals: .chipLocation)

            TextField(
                "Tatouage",
                text: ($viewModel.identification ?? viewModel.sampleIdentification).tatoo ?? ""
            )
            .customTextField(with: Image(systemName: "pencil.and.scribble"))
            .submitLabel(.next)
            .focused($focusedField, equals: .tatoo)

            TextField(
                "Localisation Tatouage",
                text: ($viewModel.identification ?? viewModel.sampleIdentification).tatooLocation ?? ""
            )
            .customTextField(with: Image(systemName: "mappin.circle.fill"))
            .submitLabel(.next)
            .focused($focusedField, equals: .tatooLocation)
        }
        .padding(.top)
    }

    @ViewBuilder private func favoriteView() -> some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Favoris", systemImage: "star.fill")

            TextField(
                "Jouet",
                text: ($viewModel.favorite ?? viewModel.sampleFavorite).toy ?? ""
            )
            .customTextField(with: Image(systemName: "teddybear.fill"))
            .submitLabel(.next)
            .focused($focusedField, equals: .toy)

            TextField(
                "Nourriture",
                text: ($viewModel.favorite ?? viewModel.sampleFavorite).food ?? ""
            )
            .customTextField(with: Image(systemName: "carrot.fill"))
            .submitLabel(.next)
            .focused($focusedField, equals: .food)

            TextField(
                "Endroit",
                text: ($viewModel.favorite ?? viewModel.sampleFavorite).place ?? ""
            )
            .customTextField(with: Image(systemName: "map.fill"))
            .submitLabel(.done)
            .focused($focusedField, equals: .place)
        }
        .padding(.top)
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return EditInformationView()
            .modelContainer(previewer.container)
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
