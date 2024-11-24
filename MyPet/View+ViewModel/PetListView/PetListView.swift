//
//  PetListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 05/08/2024.
//

import SwiftUI
import SwiftData

struct PetListView: View {

    // MARK: - PROPERTY
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    @Query private var pets: [Pet]

    @State private var isPresentingAddPetView = false
    @State private var path = NavigationPath()
    @State private var selectedPet: Pet?
    @State private var showPetTabView = false
    @State private var viewModel = ViewModel()

    // MARK: - BODY
    var body: some View {
        if let selectedPet, showPetTabView {
            PetTabView(showPetTabView: $showPetTabView)
                .environment(selectedPet)
        } else {
            NavigationStack(path: $path) {
                GeometryReader { geometry in
                    Color(.bg)
                        .ignoresSafeArea()

                    List {
                        ForEach(pets) { pet in
                            PetView(petPhotoData: pet.information.photo,
                                    petName: pet.information.name)
                            .listRowInsets(EdgeInsets())
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.3)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedPet = pet
                                    showPetTabView = true
                                }
                            }
                        }
                        .onDelete(perform: deletePet)

                        Button {
                            isPresentingAddPetView = true
                        } label: {
                            AddPetTile()
                        }
                    }
                    .listRowSpacing(15)
                    .toolbar {
                        if pets.count > 0 {
                            EditButton()
                                .environment(\.locale, .init(identifier: "fr"))
                        }
                    }
                }
                .navigationTitle("Mes animaux")
                .sheet(isPresented: $isPresentingAddPetView) {
                    AddPetView()
                }
                .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
                    Button("OK") { }
                } message: {
                    Text(viewModel.errorMessage)
                }
            }
        }
    }

    // MARK: - PRIVATE FUNCTIONS
    private func deletePet(at offsets: IndexSet) {
        viewModel.deletePet(at: offsets, pets: pets, context: modelContext)
    }
}

// MARK: - ADDITIONAL VIEWS
struct PetView: View {
    let petPhotoData: Data?
    let petName: String

    var body: some View {
        ZStack {
            if let petPhotoData, let uiImage = UIImage(data: petPhotoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .scaledToFit()
                    .padding([.top, .bottom])
            }

            Text(petName)
                .minimumScaleFactor(0.2)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: petPhotoData != nil ? .white : .black, radius: 2)
                .opacity(petPhotoData != nil ? 0.8 : 1.0)
        }
    }
}

struct AddPetTile: View {
    var body: some View {
        VStack {
            Image(systemName: "plus.circle.fill")
                .frame(maxWidth: .infinity)
                .font(.system(size: 80, weight: .bold))

            Text("Ajouter un animal")
                .font(.title)
        }
        .foregroundStyle(.gray)
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return PetListView()
            .modelContainer(previewer.container)
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
