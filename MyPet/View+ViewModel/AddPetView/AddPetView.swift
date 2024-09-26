//
//  AddPetView.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/08/2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPetView: View {

    // MARK: - PROPERTIES
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var viewModel = AddPetView.ViewModel()
    @State private var animalItem: PhotosPickerItem?
    @State private var animalImage: Image?
    @State private var photoPickerFailed = false

    @FocusState private var focusedField: FocusedField?

    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }

            VStack {
                HStack {
                    Spacer()

                    Button("Sauvegarder") {
                        addPet()
                        dismiss()
                    }
                    .disabled(viewModel.isFormValid)
                    .padding()
                }

                Form {
                    Section("Informations principales") {
                        TextField("Nom", text: $viewModel.name)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .name)

                        Picker("Genre", selection: $viewModel.gender) {
                            ForEach(Pet.Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue)
                            }
                        }

                        TextField("Type", text: $viewModel.type)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .type)

                        TextField("Race", text: $viewModel.race)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .race)

                        DatePicker("Date de naissance", selection: $viewModel.birthdate, displayedComponents: [.date])
                    }

                    Section("Informations diverses") {
                        TextField("Couleur", text: $viewModel.color)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .color)

                        TextField("Couleur des yeux", text: $viewModel.eyeColor)
                            .focused($focusedField, equals: .eyeColor)
                            .submitLabel(.done)
                    }

                    Section("Photo") {
                        PhotosPicker("Selectionnez une photo", selection: $animalItem, matching: .images)

                        animalImage?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                }
                .onSubmit {
                    if focusedField != .eyeColor {
                        focusedField = viewModel.nextField(focusedField: focusedField ?? .name)
                    }
                }
            }
            .onChange(of: animalItem) {
                Task {
                    if let imageData = try? await animalItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: imageData) {

                        viewModel.photo = imageData
                        let image = Image(uiImage: uiImage)
                        animalImage = image
                    } else {
                        photoPickerFailed = true
                    }
                }
            }
            .alert("Une erreur est survenue.", isPresented: $photoPickerFailed) {
                Button("OK") { }
            } message: {
                Text("Il semble y avoir un problème avec votre photo, essayez-en une autre.")
            }
        }
    }

    // MARK: - PRIVATE FUNCTIONS
    private func addPet() {
        let pet = Pet(
            name: viewModel.name,
            gender: viewModel.gender,
            type: viewModel.type,
            race: viewModel.race,
            birthdate: viewModel.birthdate,
            color: viewModel.color,
            eyeColor: viewModel.eyeColor,
            photo: viewModel.photo
        )

        modelContext.insert(pet)
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            AddPetView()
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
