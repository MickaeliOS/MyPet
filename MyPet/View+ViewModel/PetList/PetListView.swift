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
    @Binding var path: NavigationPath

    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            List {
                ForEach(pets) { pet in
                    PetView(petPhotoData: pet.photo, petName: pet.name)
                        .listRowInsets(EdgeInsets())
                        .frame(height: geometry.size.height * 0.3)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            path.append(pet)
                        }
                }
                .onDelete(perform: deletePet)
            }
            .listRowSpacing(15)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAddPetView.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
        .navigationTitle("Mes animaux")
        .navigationDestination(for: Pet.self, destination: { pet in
            Text(pet.name)
        })
        .sheet(isPresented: $isPresentingAddPetView) {
            AddPetView(path: $path)
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
            PetListView(path: .constant(NavigationPath()))
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
