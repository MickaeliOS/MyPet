//
//  EditInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 22/08/2024.
//

import SwiftUI

struct EditInformationView: View {

    // MARK: - PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.dismiss) private var dismiss

    @FocusState private var focusedField: FocusedField?

    private let viewModel = ViewModel()

    // MARK: - BODY
    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            ScrollView {
                ZStack {
                    HideKeyboardView()

                    VStack(alignment: .leading) {
                        identificationView(pet: $pet)
                        favoriteView(pet: $pet)
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
                    Button("Terminer") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - VIEWBUILDER
    @ViewBuilder private func identificationView(pet: Bindable<Pet>) -> some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Identification", systemImage: "cpu.fill")

            TextField(
                "Puce",
                text: (pet.identification ?? viewModel.sampleIdentification).chip ?? ""
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
                text: (pet.identification ?? viewModel.sampleIdentification).chipLocation ?? ""
            )
            .customTextField(with: Image(systemName: "mappin.circle.fill"))
            .submitLabel(.next)
            .focused($focusedField, equals: .chipLocation)

            TextField(
                "Tatouage",
                text: (pet.identification ?? viewModel.sampleIdentification).tatoo ?? ""
            )
            .customTextField(with: Image(systemName: "pencil.and.scribble"))
            .submitLabel(.next)
            .focused($focusedField, equals: .tatoo)

            TextField(
                "Localisation Tatouage",
                text: (pet.identification ?? viewModel.sampleIdentification).tatooLocation ?? ""
            )
            .customTextField(with: Image(systemName: "mappin.circle.fill"))
            .submitLabel(.next)
            .focused($focusedField, equals: .tatooLocation)
        }
        .padding(.top)
    }

    @ViewBuilder private func favoriteView(pet: Bindable<Pet>) -> some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Favoris", systemImage: "star.fill")

            TextField(
                "Jouet",
                text: (pet.favorite ?? viewModel.sampleFavorite).toy ?? ""
            )
            .customTextField(with: Image(systemName: "teddybear.fill"))
            .submitLabel(.next)
            .focused($focusedField, equals: .toy)

            TextField(
                "Nourriture",
                text: (pet.favorite ?? viewModel.sampleFavorite).food ?? ""
            )
            .customTextField(with: Image(systemName: "carrot.fill"))
            .submitLabel(.next)
            .focused($focusedField, equals: .food)

            TextField(
                "Endroit",
                text: (pet.favorite ?? viewModel.sampleFavorite).place ?? ""
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
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
