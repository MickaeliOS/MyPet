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

    // MARK: - PROPERTY
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @FocusState private var focusedField: FocusedField?

    @State private var viewModel = AddPetView.ViewModel()
    @State private var photoPickerCenter = PhotoPickerCenter()

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    HideKeyboardView()

                    VStack(alignment: .leading) {
                        principalInformationsView()
                        colorInformationsView()
                        photoView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding([.leading, .trailing])
                    .onSubmit {
                        if focusedField != .eyeColor {
                            focusedField = viewModel.nextField(focusedField: focusedField ?? .name)
                        }
                    }
                    .onChange(of: photoPickerCenter.item) {
                        Task {
                            guard let photo = await photoPickerCenter.setupPhoto() else {
                                return
                            }

                            viewModel.photo = photo
                        }
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .navigationTitle("Ajouter un animal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sauvegarder") {
                        if viewModel.addPet(modelContext: modelContext) {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .alert("Une erreur est survenue.", isPresented: $photoPickerCenter.showingAlert) {
                Button("OK") { }
            } message: {
                Text(photoPickerCenter.errorMessage)
            }
            .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }

    @ViewBuilder private func principalInformationsView() -> some View {
        VStack {
            VStack(alignment: .leading) {
                TextField("Nom", text: $viewModel.name)
                    .customTextField(with: Image(systemName: "person.fill"))
                    .submitLabel(.next)
                    .focused($focusedField, equals: .name)

                TextField("Type", text: $viewModel.type)
                    .customTextField(with: Image(systemName: "pawprint.fill"))
                    .submitLabel(.next)
                    .focused($focusedField, equals: .type)

                TextField("Race", text: $viewModel.race)
                    .customTextField(with: Image(systemName: "questionmark.circle.fill"))
                    .submitLabel(.next)
                    .focused($focusedField, equals: .race)
            }
            .padding(.bottom)

            VStack(alignment: .leading, spacing: 20) {
                Label("Genre", systemImage: "questionmark.circle.fill")
                    .imageScale(.large)
                    .font(.title3)

                Picker("Genre", selection: $viewModel.gender) {
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

                    DatePicker("Date de naissance", selection: $viewModel.birthdate, displayedComponents: [.date])
                        .bold()
                        .labelsHidden()
                }
            }
        }
        .padding(.bottom)
    }

    @ViewBuilder private func colorInformationsView() -> some View {
        VStack {
            TextField("Couleur", text: $viewModel.color)
                .customTextField(with: Image(systemName: "paintpalette.fill"))
                .submitLabel(.next)
                .focused($focusedField, equals: .color)

            TextField("Couleur des yeux", text: $viewModel.eyeColor)
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

        return AddPetView()
            .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
