//
//  EditInformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 22/08/2024.
//

import SwiftUI
import PhotosUI

struct EditInformationView: View {

    // MARK: - PROPERTIES
    @Environment(Pet.self) var pet
    @Environment(\.dismiss) var dismiss

    @State private var animalItem: PhotosPickerItem?
    @State private var animalImage: Image?
    @State private var photoPickerFailed = false

    @FocusState private var focusedField: FocusedField?

    let viewModel = ViewModel()

    // MARK: - BODY
    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    principalInformationsView(pet: $pet)
                    colorInformationsView(pet: $pet)
                    photoView()
                    identificationView(pet: $pet)
                    favoriteView(pet: $pet)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding([.leading, .trailing])
                .onChange(of: animalItem) {
                    Task {
                        if let imageData = try? await animalItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: imageData) {

                            pet.information.photo = imageData
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
//            .onTapGesture {
//                hideKeyboard()
//            }
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

    // MARK: - VIEW FUNCTION
    @ViewBuilder private func principalInformationsView(pet: Bindable<Pet>) -> some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Informations", systemImage: "info.square.fill")
                .padding(.top)

            VStack(alignment: .leading) {
                TextField("Nom", text: pet.information.name)
                    .customTextField(with: Image(systemName: "person.fill"))
                    .submitLabel(.next)
                    .focused($focusedField, equals: .name)

                TextField("Type", text: pet.information.type)
                    .customTextField(with: Image(systemName: "pawprint.fill"))
                    .submitLabel(.next)
                    .focused($focusedField, equals: .type)

                TextField("Race", text: pet.information.race)
                    .customTextField(with: Image(systemName: "questionmark.circle.fill"))
                    .submitLabel(.next)
                    .focused($focusedField, equals: .race)
            }
            .padding(.bottom)

            VStack(alignment: .leading, spacing: 20) {
                Label("Genre", systemImage: "questionmark.circle.fill")
                    .imageScale(.large)
                    .font(.title3)

                Picker("Genre", selection: pet.information.gender) {
                    ForEach(Information.Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Label("Date de naissance", systemImage: "birthday.cake.fill")
                        .imageScale(.large)
                        .font(.title3)

                    Spacer()

                    DatePicker("Date de naissance", selection: pet.information.birthdate, displayedComponents: [.date])
                        .bold()
                        .labelsHidden()
                }
            }
        }
        .padding(.bottom)
    }

    @ViewBuilder private func colorInformationsView(pet: Bindable<Pet>) -> some View {
        VStack {
            TextField("Couleur", text: pet.information.color)
                .customTextField(with: Image(systemName: "paintpalette.fill"))
                .submitLabel(.next)
                .focused($focusedField, equals: .color)

            TextField("Couleur des yeux", text: pet.information.eyeColor)
                .customTextField(with: Image(systemName: "eye.fill"))
                .submitLabel(.next)
                .focused($focusedField, equals: .eyeColor)
        }
        .padding(.bottom)
    }

    @ViewBuilder private func photoView() -> some View {
        VStack {
            PhotosPicker("Selectionnez une photo", selection: $animalItem, matching: .images)
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient.linearBlue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .font(.title3)

            animalImage?
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder private func identificationView(pet: Bindable<Pet>) -> some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Identification", systemImage: "cpu.fill")

            TextField(
                "Puce",
                value: (pet.identification ?? viewModel.sampleIdentification).chip,
                format: .number
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
