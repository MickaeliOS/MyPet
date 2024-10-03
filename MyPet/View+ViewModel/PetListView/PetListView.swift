//
//  PetListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 05/08/2024.
//

import SwiftUI
import SwiftData

struct PetListView: View {

    // MARK: - PROPERTIES
    @Query var pets: [Pet]
    @Environment(\.modelContext) var modelContext
    @State private var isPresentingAddPetView = false
    @State private var path = NavigationPath()
    @State private var selectedPet: Pet?
    @State private var showPetTabView = false

    // MARK: - BODY
    var body: some View {
        if let selectedPet, showPetTabView {
            PetTabView(showPetTabView: $showPetTabView)
                .environment(selectedPet)
        } else {
            NavigationStack(path: $path) {
                GeometryReader { geometry in
                    if pets.isEmpty {
                        EmptyListView(
                            emptyListMessage: """
                            La liste est vide, ajouter vos animaux en appuyant
                            sur le bouton + situé en haut à droite de l'écran.
                            """,
                            messageFontSize: .title2
                        )
                        .position(x: geometry.frame(in: .local).midX,
                                  y: geometry.frame(in: .local).midY)
                    } else {
                        List {
                            ForEach(pets) { pet in
                                PetView(petPhotoData: pet.information.photo, petName: pet.information.name)
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
                        }
                        .listRowSpacing(15)
                    }
                }
                .navigationTitle("Mes animaux")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isPresentingAddPetView = true
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                        })
                        .font(.title)
                        .buttonLinearGradient(for: .foreground)
                    }
                }
                .sheet(isPresented: $isPresentingAddPetView) {
                    AddPetView()
                }
            }
        }
    }

    // MARK: - PRIVATE FUNCTIONS
    private func deletePet(at offsets: IndexSet) {
        for offset in offsets {
            let pet = pets[offset]
            modelContext.delete(pet)
        }
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
                .minimumScaleFactor(0.5)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: petPhotoData != nil ? .white : .black, radius: 10, x: 0, y: 5)
                .opacity(petPhotoData != nil ? 0.8 : 1.0)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            PetListView()
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
