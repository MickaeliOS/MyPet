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
    @Binding var selectedPet: Pet?

    private let emptyListMessage = """
    La liste est vide, ajouter vos animaux
    en appuyant sur le bouton + situé en haut à
    droite de l'écran.
    """

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                if pets.isEmpty {
                    VStack {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 80))

                        Text(emptyListMessage)
                            .font(.title2)
                    }
                    .padding()
                    .position(x: geometry.frame(in: .local).midX,
                              y: geometry.frame(in: .local).midY)
                    .foregroundStyle(.secondary)
                } else {
                    List {
                        ForEach(pets) { pet in
                            PetView(petPhotoData: pet.photo, petName: pet.name)
                                .listRowInsets(EdgeInsets())
                                .frame(maxWidth: .infinity)
                                .frame(height: geometry.size.height * 0.3)
                                .onTapGesture {
                                    withAnimation {
                                        selectedPet = pet
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
                    Button {
                        isPresentingAddPetView.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingAddPetView) {
            AddPetView()
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
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                .opacity(petPhotoData != nil ? 0.5 : 1.0)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            PetListView(selectedPet: .constant(previewer.firstPet))
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
