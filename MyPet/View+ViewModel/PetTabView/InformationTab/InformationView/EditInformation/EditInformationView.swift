//
//  EditInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 22/08/2024.
//

import SwiftUI
import PhotosUI

struct EditInformationView: View {
    @Environment(Pet.self) var pet
    @Environment(\.dismiss) var dismiss

    @State private var animalItem: PhotosPickerItem?
    @State private var animalImage: Image?
    @State private var photoPickerFailed = false

    @FocusState private var focusedField: FocusedField?

    let viewModel = ViewModel()

    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            VStack {
                Form {
                    Section("Informations principales") {
                        TextField("Nom", text: $pet.information.name)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .name)
                            .keyboardType(.namePhonePad)

                        Picker("Genre", selection: $pet.information.gender) {
                            ForEach(Information.Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue)
                            }
                        }

                        TextField("Type", text: $pet.information.type)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .type)

                        TextField("Race", text: $pet.information.race)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .race)

                        DatePicker(
                            "Date de naissance",
                            selection: $pet.information.birthdate,
                            displayedComponents: [.date]
                        )
                    }

                    Section("Informations diverses") {
                        TextField("Couleur", text: $pet.information.color)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .color)

                        TextField("Couleur des yeux", text: $pet.information.eyeColor)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .eyeColor)
                    }

                    Section("Photo") {
                        PhotosPicker("Selectionnez une photo", selection: $animalItem, matching: .images)

                        animalImage?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }

                    Section("Identification") {
                        TextField(
                            "Puce",
                            value: ($pet.identification ?? viewModel.sampleIdentification).chip,
                            format: .number
                        )
                        .focused($focusedField, equals: .chip)
                        .keyboardType(.numberPad)

                        TextField(
                            "Localisation Puce",
                            text: ($pet.identification ?? viewModel.sampleIdentification).chipLocation ?? ""
                        )
                        .submitLabel(.next)
                        .focused($focusedField, equals: .chipLocation)

                        TextField(
                            "Tatouage",
                            text: ($pet.identification ?? viewModel.sampleIdentification).tatoo ?? ""
                        )
                        .submitLabel(.next)
                        .focused($focusedField, equals: .tatoo)

                        TextField(
                            "Localisation Tatouage",
                            text: ($pet.identification ?? viewModel.sampleIdentification).tatooLocation ?? ""
                        )
                        .submitLabel(.next)
                        .focused($focusedField, equals: .tatooLocation)
                    }

                    Section("Favoris") {
                        TextField(
                            "Jouet",
                            text: ($pet.favorite ?? viewModel.sampleFavorite).toy ?? ""
                        )
                        .submitLabel(.next)
                        .focused($focusedField, equals: .toy)

                        TextField(
                            "Nourriture",
                            text: ($pet.favorite ?? viewModel.sampleFavorite).food ?? ""
                        )
                        .submitLabel(.next)
                        .focused($focusedField, equals: .food)

                        TextField(
                            "Endroit",
                            text: ($pet.favorite ?? viewModel.sampleFavorite).place ?? ""
                        )
                        .submitLabel(.done)
                        .focused($focusedField, equals: .place)
                    }
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
                        dismiss()
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

        return EditInformationView()
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
