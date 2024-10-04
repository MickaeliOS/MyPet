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

    @State var viewModel = ViewModel()
    @State private var showInformationView = false
    @State private var showHealthInformationView = false

    @Binding var showPetTabView: Bool

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        ZStack(alignment: .bottomLeading) {
                            ProfilePictureView(geometry: geometry)
                            PetToolBarView(showPetTabView: $showPetTabView, viewModel: viewModel)
                        }

                        GeneralInformation(
                            geometry: geometry,
                            viewModel: viewModel
                        )

                        Spacer()

                        InformationListButton(
                            showView: $showInformationView,
                            buttonName: "Informations",
                            buttonSystemImage: "info.circle.fill"
                        )

                        InformationListButton(
                            showView: $showHealthInformationView,
                            buttonName: "Infos. Médicales",
                            buttonSystemImage: "cross.case.fill"
                        )
                    }
                }
            }
            .navigationDestination(isPresented: $showInformationView) {
                InformationView()
            }
            .navigationDestination(isPresented: $showHealthInformationView) {
                HealthInformationView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.requestAuthorizationForNotifications()
            }
            .alert("Erreur", isPresented: $viewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return TabView {
            InformationListView(showPetTabView: .constant(true))
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
struct PetToolBarView: View {
    @Environment(Pet.self) var pet
    @Binding var showPetTabView: Bool
    var viewModel: InformationListView.ViewModel

    var body: some View {
        HStack {
            HStack {
                Text(pet.information.name)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)

                Image(viewModel.getGender(gender: pet.information.gender))
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding()
            .background(.white)
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 15)
            .padding(.leading)

            Spacer()

            Button {
                withAnimation(.easeInOut) {
                    showPetTabView = false
                }
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .foregroundStyle(.white)
                    .padding(10)
                    .buttonLinearGradient(for: .background)
                    .clipShape(Circle())
            }
            .overlay {
                Circle()
                    .stroke(Color(UIColor.systemBackground), lineWidth: 4)
            }
            .padding()
        }
        .alignmentGuide(VerticalAlignment.bottom,
                        computeValue: { value in
            value[VerticalAlignment.center]
        })
    }
}

struct ProfilePictureView: View {
    @Environment(Pet.self) var pet
    @State private var petPhoto: Image?

    let geometry: GeometryProxy

    var body: some View {
        VStack {
            petPhoto?
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipped()
        }
        .frame(maxWidth: geometry.size.width)
        .onAppear {
            setupPetPhoto()
        }
    }

    private func setupPetPhoto() {
        if let imageData = pet.information.photo,
           let uiImage = UIImage(data: imageData) {

            petPhoto = Image(uiImage: uiImage)
        } else {
            petPhoto = Image(systemName: "pawprint.fill")
        }
    }
}

struct GeneralInformation: View {
    @Environment(Pet.self) var pet
    let geometry: GeometryProxy
    var viewModel: InformationListView.ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack {
                Text("""
                 \(pet.information.type), \
                 \(pet.information.race), \
                 \(pet.information.getStringAge) \(pet.information.getStringAge > "1" ? "ans" : "an")
                 """)
                .font(.title2)
            }

            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text(pet.information.birthdate.dateToStringDMY)
                } icon: {
                    Image(systemName: "calendar")
                }

                Label {
                    Text(pet.information.color)
                } icon: {
                    Image(systemName: "paintpalette")
                }

                Label {
                    Text(pet.information.eyeColor)
                } icon: {
                    Image(systemName: "eye")
                }
            }
            .font(.callout)
        }
        .padding(.leading)
    }
}

struct InformationListButton: View {
    @Binding var showView: Bool
    let buttonName: String
    let buttonSystemImage: String

    var body: some View {
        Button {
            showView = true
        } label: {
            HStack {
                Label(buttonName, systemImage: buttonSystemImage)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .font(.title)
        .foregroundStyle(.white)
        .buttonLinearGradient(for: .background)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding([.leading, .trailing])
    }
}
