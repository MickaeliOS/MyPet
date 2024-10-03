//
//  AddPetView.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/08/2024.
//

import SwiftUI
import SwiftData
import PhotosUI

//struct AddPetView: View {
//
//    // MARK: - PROPERTIES
//    @Environment(\.modelContext) var modelContext
//    @Environment(\.dismiss) var dismiss
//
//    @State private var viewModel = AddPetView.ViewModel()
//    @State private var animalItem: PhotosPickerItem?
//    @State private var animalImage: Image?
//    @State private var photoPickerFailed = false
//
//    @FocusState private var focusedField: FocusedField?
//
//    // MARK: - BODY
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                Color.clear
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        focusedField = nil
//                    }
//
//                VStack(alignment: .leading) {
//                    principalInformations()
//                    colorInformations()
//                    photo()
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                .padding([.leading, .trailing])
//                .onSubmit {
//                    if focusedField != .eyeColor {
//                        focusedField = viewModel.nextField(focusedField: focusedField ?? .name)
//                    }
//                }
//                .onChange(of: animalItem) {
//                    Task {
//                        if let imageData = try? await animalItem?.loadTransferable(type: Data.self),
//                           let uiImage = UIImage(data: imageData) {
//
//                            viewModel.photo = imageData
//                            let image = Image(uiImage: uiImage)
//                            animalImage = image
//                        } else {
//                            photoPickerFailed = true
//                        }
//                    }
//                }
//                .alert("Une erreur est survenue.", isPresented: $photoPickerFailed) {
//                    Button("OK") { }
//                } message: {
//                    Text("Il semble y avoir un problème avec votre photo, essayez-en une autre.")
//                }
//            }
//            .navigationTitle("Ajouter un animal")
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Sauvegarder") {
//                        addPet()
//                        dismiss()
//                    }
//                    .disabled(viewModel.isFormValid)
//                }
//            }
//        }
//    }
//
//    @ViewBuilder private func principalInformations() -> some View {
//        VStack {
//            VStack(alignment: .leading) {
//                TextField("Nom", text: $viewModel.name)
//                    .customTextField(with: Image(systemName: "person.fill"))
//                    .submitLabel(.next)
//                    .focused($focusedField, equals: .name)
//
//                TextField("Type", text: $viewModel.type)
//                    .customTextField(with: Image(systemName: "pawprint.fill"))
//                    .submitLabel(.next)
//                    .focused($focusedField, equals: .type)
//
//                TextField("Race", text: $viewModel.race)
//                    .customTextField(with: Image(systemName: "questionmark.circle.fill"))
//                    .submitLabel(.next)
//                    .focused($focusedField, equals: .race)
//            }
//            .padding(.bottom)
//
//            VStack(alignment: .leading, spacing: 20) {
//                Label("Genre", systemImage: "questionmark.circle.fill")
//                    .imageScale(.large)
//                    .font(.title3)
//
//                Picker("Genre", selection: $viewModel.gender) {
//                    ForEach(Information.Gender.allCases, id: \.self) { gender in
//                        Text(gender.rawValue)
//                    }
//                }
//                .pickerStyle(.segmented)
//
//                HStack {
//                    Label("Date de naissance", systemImage: "birthday.cake.fill")
//                        .imageScale(.large)
//                        .font(.title3)
//
//                    Spacer()
//
//                    DatePicker("Date de naissance", selection: $viewModel.birthdate, displayedComponents: [.date])
//                        .bold()
//                        .labelsHidden()
//                }
//            }
//        }
//        .padding(.bottom)
//    }
//
//    @ViewBuilder private func colorInformations() -> some View {
//        VStack {
//            TextField("Couleur", text: $viewModel.color)
//                .customTextField(with: Image(systemName: "paintpalette.fill"))
//                .submitLabel(.next)
//                .focused($focusedField, equals: .color)
//
//            TextField("Couleur des yeux", text: $viewModel.eyeColor)
//                .customTextField(with: Image(systemName: "eye.fill"))
//                .submitLabel(.done)
//                .focused($focusedField, equals: .eyeColor)
//        }
//        .padding(.bottom)
//    }
//
//    @ViewBuilder private func photo() -> some View {
//        VStack {
//            PhotosPicker("Selectionnez une photo", selection: $animalItem, matching: .images)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .buttonLinearGradient(for: .background)
//                .foregroundStyle(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .font(.title3)
//
//            animalImage?
//                .resizable()
//                .scaledToFit()
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .frame(maxWidth: .infinity)
//        }
//        .frame(maxWidth: .infinity)
//    }
//
//    // MARK: - PRIVATE FUNCTIONS
//    private func addPet() {
//        let information = Information(
//            name: viewModel.name,
//            gender: viewModel.gender,
//            type: viewModel.type,
//            race: viewModel.race,
//            birthdate: viewModel.birthdate,
//            color: viewModel.color,
//            eyeColor: viewModel.eyeColor,
//            photo: viewModel.photo
//        )
//
//        modelContext.insert(Pet(information: information))
//    }
//}
//
//// MARK: - PREVIEW
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





// TEST

struct AddPetView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
//    @FocusState private var focusedField: FocusedField?

    private var informationPetViewModel = InformationPetView.ViewModel()

    var body: some View {
        NavigationStack {
            InformationPetView(viewModel: informationPetViewModel)
                .navigationTitle("Ajouter un Animal")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Ajouter") {
                            addPet()
                            dismiss()
                        }
                        .disabled(informationPetViewModel.isFormValid)
                    }
                }
        }
    }

    private func addPet() {
        let information = Information(
            name: informationPetViewModel.name,
            gender: informationPetViewModel.gender,
            type: informationPetViewModel.type,
            race: informationPetViewModel.race,
            birthdate: informationPetViewModel.birthdate,
            color: informationPetViewModel.color,
            eyeColor: informationPetViewModel.eyeColor,
            photo: informationPetViewModel.photo
        )

        modelContext.insert(Pet(information: information))
    }
}

struct InformationPetView: View {
    @State var viewModel: InformationPetView.ViewModel
    @State private var animalItem: PhotosPickerItem?
    @State private var animalImage: Image?
    @State private var photoPickerFailed = false

    @FocusState private var focusedField: FocusedField?

    var body: some View {
        ScrollView {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }

            VStack(alignment: .leading) {
                principalInformations()
                colorInformations()
                photo()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding([.leading, .trailing])
            .onSubmit {
                if focusedField != .eyeColor {
                    focusedField = viewModel.nextField(focusedField: focusedField ?? .name)
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

    @ViewBuilder private func principalInformations() -> some View {
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

    @ViewBuilder private func colorInformations() -> some View {
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

    @ViewBuilder private func photo() -> some View {
        VStack {
            PhotosPicker("Selectionnez une photo", selection: $animalItem, matching: .images)
                .frame(maxWidth: .infinity)
                .padding()
                .buttonLinearGradient(for: .background)
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
}

extension InformationPetView {

    @Observable
    final class ViewModel {
        var name = ""
        var gender = Information.Gender.male
        var race = ""
        var type = ""
        var birthdate = Date.now
        var eyeColor = ""
        var color = ""
        var photo: Data?

        var isFormValid: Bool {
            (
                name.isReallyEmpty ||
                race.isReallyEmpty ||
                type.isReallyEmpty ||
                eyeColor.isReallyEmpty ||
                color.isReallyEmpty
            )
        }

        func nextField(focusedField: FocusedField) -> FocusedField {
            let transitions: [FocusedField: FocusedField] = [
                .name: .type,
                .type: .race,
                .race: .color,
                .color: .eyeColor,
                .eyeColor: .eyeColor
            ]

            return transitions[focusedField] ?? .name
        }
    }

    enum FocusedField {
        case name
        case type
        case race
        case color
        case eyeColor
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack { AddPetView() }
            .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
