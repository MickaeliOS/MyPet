//
//  EditInformationListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 23/10/2024.
//

import SwiftUI
import PhotosUI

struct EditInformationListView: View {

    // MARK: - PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.dismiss) private var dismiss

    @FocusState private var focusedField: FocusedField?

    @State private var viewModel = ViewModel()
    @State private var photoPickerCenter = PhotoPickerCenter()

    // MARK: - BODY
    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            ScrollView {
                ZStack {
                    HideKeyboardView()

                    VStack(alignment: .leading) {
                        principalInformationsView(pet: $pet)
                        colorInformationsView(pet: $pet)
                        photoView()
                    }
                    .onChange(of: photoPickerCenter.item) {
                        Task {
                            guard let photo = await photoPickerCenter.setupPhoto() else {
                                return
                            }

                            pet.information.photo = photo
                        }
                    }
                    .onSubmit {
                        if focusedField != .eyeColor {
                            focusedField = viewModel.nextField(focusedField: focusedField ?? .name)
                        }
                    }
                    .alert("Une erreur est survenue.", isPresented: $photoPickerCenter.showingAlert) {
                        Button("OK") { }
                    } message: {
                        Text(photoPickerCenter.errorMessage)
                    }
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
            .padding()
        }
    }

    // MARK: - VIEWBUILDER
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
                .submitLabel(.done)
                .focused($focusedField, equals: .eyeColor)
        }
        .padding(.bottom)
    }

    @ViewBuilder private func photoView() -> some View {
        VStack {
            PhotosPicker("Selectionnez une photo", selection: $photoPickerCenter.item, matching: .images)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .font(.title3)

            photoPickerCenter.image?
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxWidth: .infinity, maxHeight: 400)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return EditInformationListView()
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
