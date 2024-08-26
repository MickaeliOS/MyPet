//
//  PetInformationForm.swift
//  MyPet
//
//  Created by Mickaël Horn on 23/08/2024.
//

import SwiftUI
import PhotosUI
import SwiftData

struct PetInformationForm: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = ViewModel()
    @State private var animalItem: PhotosPickerItem?
    @State private var animalImage: Image?
    @State private var photoPickerFailed = false

    var body: some View {
        Form {
            Section("Informations principales") {
                TextField("Nom", text: $viewModel.name)

                Picker("Genre", selection: $viewModel.gender) {
                    ForEach(Pet.Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }

                TextField("Type", text: $viewModel.type)
                TextField("Race", text: $viewModel.race)

                DatePicker("Date de naissance", selection: $viewModel.birthdate, displayedComponents: [.date])
            }

            Section("Informations diverses") {
                TextField("Couleur", text: $viewModel.color)
                TextField("Couleur des yeux", text: $viewModel.eyeColor)
            }

            Section("Photo") {
                PhotosPicker("Selectionnez une photo", selection: $animalItem, matching: .images)

                animalImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
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

#Preview {
    PetInformationForm()
}

//#Preview {
//    do {
//        let previewer = try Previewer()
//
//        return AddPetView()
//            .modelContainer(previewer.container)
//
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}
