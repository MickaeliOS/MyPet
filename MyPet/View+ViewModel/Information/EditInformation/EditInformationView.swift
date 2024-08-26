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

    let viewModel = ViewModel()

    var body: some View {
        @Bindable var pet = pet

        Form {
            Section("Informations principales") {
                TextField("Nom", text: $pet.name)

                Picker("Genre", selection: $pet.gender) {
                    ForEach(Pet.Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }

                TextField("Type", text: $pet.type)
                TextField("Race", text: $pet.race)

                DatePicker(
                    "Date de naissance",
                    selection: $pet.birthdate,
                    displayedComponents: [.date]
                )
            }

            Section("Informations diverses") {
                TextField("Couleur", text: $pet.color)
                TextField("Couleur des yeux", text: $pet.eyeColor)
            }

            Section("Photo") {
                PhotosPicker("Selectionnez une photo", selection: $animalItem, matching: .images)

                animalImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }

            Section("Identification") {
                TextField("Chip", value: ($pet.identification ?? viewModel.sampleIdentification).chip, format: .number)
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
