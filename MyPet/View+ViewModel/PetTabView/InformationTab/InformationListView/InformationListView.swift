//
//  InformationListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import SwiftUI

// MARK: - MAIN VIEW
struct InformationListView: View {
    @Environment(Pet.self) var pet

    @State private var isPresentingEditInformationView = false
    @State var viewModel = ViewModel()

    @Binding var showPetTabView: Bool

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        ProfilePictureView(geometry: geometry)
                        GeneralInformation(showPetTabView: $showPetTabView, geometry: geometry, viewModel: viewModel)
                        VariousInformation()
                        IdentificationView(viewModel: viewModel)
                        FavoriteView(viewModel: viewModel)
                    }
                    .padding([.leading, .trailing])
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    OpenModalButton(
                        isPresentingView: $isPresentingEditInformationView,
                        content: EditInformationView(),
                        systemImage: "pencil.line"
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return TabView {
            InformationView(showPetTabView: .constant(true))
                .environment(previewer.firstPet)
                .tabItem {
                    Label(
                        Category.infos.rawValue,
                        systemImage: Category.infos.imageName
                    )
                }
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

// MARK: - CHILD VIEWS
struct ProfilePictureView: View {
    @Environment(Pet.self) var pet
    @State private var petPhoto: Image?

    let geometry: GeometryProxy

    var body: some View {
        VStack {
            petPhoto?
                .resizable()
                .scaledToFit()
                .frame(height: geometry.size.height * 0.25)
                .clipShape(Circle())
                .overlay(Circle().stroke(.black, lineWidth: 4))
                .shadow(color: .black, radius: 1)
                .frame(maxWidth: .infinity)
        }
        .onAppear {
            setupPetPhoto()
        }
    }

    private func setupPetPhoto() {
        if let imageData = pet.photo,
           let uiImage = UIImage(data: imageData) {

            petPhoto = Image(uiImage: uiImage)
        } else {
            petPhoto = Image(systemName: "pawprint.fill")
        }
    }
}

struct GeneralInformation: View {
    @Environment(Pet.self) var pet
    @Binding var showPetTabView: Bool
    let geometry: GeometryProxy
    var viewModel: InformationView.ViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(pet.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)

                Image(viewModel.getGender(gender: pet.gender))
                    .resizable()
                    .frame(width: 30, height: 30)

                Spacer()

                Button {
                    withAnimation(.easeInOut) {
                        showPetTabView = false
                    }
                } label: {
                    Label("Changer", systemImage: "arrow.left.arrow.right")
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.teal)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }

            HStack {
                Text(pet.type)
                    .padding(.trailing)

                ThickDividerView(orientation: .vertical)

                Text(pet.race)
                    .padding([.leading, .trailing])

                ThickDividerView(orientation: .vertical)

                Text("\(pet.getStringAge) \(pet.getStringAge > "1" ? "ans" : "an" )")
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity)
            .frame(height: geometry.size.height * 0.1)
            .padding([.top, .bottom])
        }
    }
}

struct IdentificationView: View {
    @Environment(Pet.self) var pet
    var viewModel: InformationView.ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CategoryGrayTitleView(text: "Identification", systemImage: "cpu")

            Text("Puce")
                .bold()
            Text(pet.identification?.chip.map { "\($0)" } ?? "Non renseigné")

            Text("Localisation Puce")
                .bold()
            Text(viewModel.orDefault(pet.identification?.chipLocation))

            Text("Tatouage")
                .bold()
            Text(viewModel.orDefault(pet.identification?.tatoo))

            Text("Localisation Tatouage")
                .bold()
            Text(viewModel.orDefault(pet.identification?.tatooLocation))
        }
    }
}

struct VariousInformation: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text(pet.birthdate.dateToStringDMY)
            } icon: {
                Image(systemName: "calendar")
                    .font(.title3)
            }

            Label {
                Text(pet.color)
            } icon: {
                Image(systemName: "paintpalette")
                    .font(.title3)
            }

            Label {
                Text(pet.eyeColor)
            } icon: {
                Image(systemName: "eye")
                    .font(.title3)
            }
        }
    }
}

struct FavoriteView: View {
    @Environment(Pet.self) var pet
    var viewModel: InformationView.ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CategoryGrayTitleView(text: "Favoris", systemImage: "star.fill")

            Text("Jouet")
                .bold()
            Text(viewModel.orDefault(pet.favorite?.toy))

            Text("Nourriture")
                .bold()
            Text(viewModel.orDefault(pet.favorite?.food))

            Text("Endroit")
                .bold()
            Text(viewModel.orDefault(pet.favorite?.place))
        }
    }
}
