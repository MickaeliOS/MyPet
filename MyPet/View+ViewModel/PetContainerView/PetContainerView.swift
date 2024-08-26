//
//  PetContainerView.swift
//  MyPet
//
//  Created by Mickaël Horn on 19/08/2024.
//

import SwiftUI

struct PetContainerView: View {
    @Environment(Pet.self) var pet
    @State private var selectedCategory: Category = .infos
    @State private var petPhoto: Image?

    var body: some View {
        GeometryReader { geometry in
            VStack {
                petPhoto?
                    .resizable()
                    .scaledToFit()
                    .frame(height: geometry.size.height * 0.25)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.black, lineWidth: 4))
                    .shadow(color: .black, radius: 1)
                    .frame(maxWidth: .infinity)

                MenuView(selectedCategory: $selectedCategory)

                switch selectedCategory {
                case .infos:
                    InformationView()
                case .sante:
                    Text("Santé")
                case .charts:
                    Text("Suivi")
                }
            }
            .onAppear {
                setupPetPhoto()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(pet.name)
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

struct MenuView: View {
    @Binding var selectedCategory: Category

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(Category.allCases, id: \.self) { category in
                    MenuIconView(
                        imageName: category.imageName,
                        category: category,
                        selectedCategory: $selectedCategory
                    )
                }
            }
            .padding()
        }
    }
}

struct MenuIconView: View {
    let imageName: String
    let category: Category
    @Binding var selectedCategory: Category

    var body: some View {
        Button {
            selectedCategory = category
        } label: {
            VStack {
                Image(systemName: imageName)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)

                Text(category.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 70)
            .background(
                selectedCategory == category ? Color.blue : Color.gray
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: selectedCategory == category ? Color.black.opacity(0.4) : Color.black.opacity(0.1),
                radius: 10,
                x: 0,
                y: 0
            )
        }
    }
}

enum Category: String, CaseIterable {
    case infos = "Infos"
    case sante = "Santé"
    case charts = "Suivi"

    var imageName: String {
        switch self {
        case .infos:
            return "list.bullet.clipboard"
        case .sante:
            return "heart"
        case .charts:
            return "chart.xyaxis.line"
        }
    }
}

#Preview {
    NavigationStack {
        PetContainerView()
            .environment(try? Previewer().firstPet)
    }
}
