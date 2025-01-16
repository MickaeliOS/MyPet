//
//  InformationListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import SwiftUI

struct InformationListView: View {

    // MARK: PROPERTY
    @Environment(Pet.self) private var pet

    @State private var viewModel = ViewModel()
    @State private var showInformationView = false
    @State private var showHealthInformationView = false
    @State private var showEditInformationListView = false

    @Binding var showPetTabView: Bool

    // MARK: BODY
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        ZStack(alignment: .bottomLeading) {
                            profilePictureView(geometry: geometry)
                            petToolBarView()
                        }

                        generalInformations()

                        CategoryTitleView(text: "Informations", systemImage: "info.circle.fill")
                            .padding(.leading)

                        HStack {
                            VStack {
                                InformationListButton(
                                    showView: $showInformationView,
                                    buttonName: "Générales",
                                    buttonSystemImage: "info.circle.fill"
                                )
                            }

                            VStack {
                                InformationListButton(
                                    showView: $showHealthInformationView,
                                    buttonName: "Médicales",
                                    buttonSystemImage: "cross.case.fill"
                                )
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .trailing])
                    }
                }
            }
            .navigationTitle("Profil")
            .navigationDestination(isPresented: $showInformationView) {
                InformationView()
            }
            .navigationDestination(isPresented: $showHealthInformationView) {
                HealthInformationView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
                await viewModel.requestAuthorizationForNotifications()
            }
            .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showEditInformationListView = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .font(.title2)
                    .foregroundStyle(.blue)
                }
            }
            .sheet(isPresented: $showEditInformationListView) {
                EditInformationListView()
            }
        }
    }

    // MARK: VIEWBUILDER
    @ViewBuilder private func profilePictureView(geometry: GeometryProxy) -> some View {
        VStack {
            viewModel.petPhoto?
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipped()
        }
        .frame(maxWidth: geometry.size.width)
        .onAppear {
            viewModel.setupPetPhoto(with: pet.information.photo)
        }
        .onChange(of: pet.information.photo) {
            viewModel.setupPetPhoto(with: pet.information.photo)
        }
    }

    @ViewBuilder private func petToolBarView() -> some View {
        HStack {
            HStack {
                Text(pet.information.name)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)

                Image(pet.information.gender.getGenderImage)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding()
            .background(.white)
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color(UIColor.label).opacity(0.5), radius: 15)
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
                    .background(.blue)
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

    @ViewBuilder private func generalInformations() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack {
                Text("""
                 \(pet.information.type), \
                 \(pet.information.race), \
                 \(pet.information.getStringAge)
                 """)
                .font(.title2)
            }

            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text(pet.information.birthdate.dateToStringDMY)
                } icon: {
                    Image(systemName: "birthday.cake")
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

// MARK: - CHILD VIEW
struct InformationListButton: View {
    @Binding var showView: Bool
    let buttonName: String
    let buttonSystemImage: String

    var body: some View {
        Button {
            showView = true
        } label: {
            HStack {
                Image(systemName: buttonSystemImage)
                    .font(.title)

                Text(buttonName)
                    .font(.title3)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return TabView {
            InformationListView(showPetTabView: .constant(true))
                .modelContainer(previewer.container)
                .environment(previewer.firstPet)
                .tabItem {
                    Label(
                        PetTabView.Category.infos.rawValue,
                        systemImage: PetTabView.Category.infos.imageName
                    )
                }
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
