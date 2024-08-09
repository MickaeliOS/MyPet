//
//  InformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import SwiftUI

struct InformationView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        GeometryReader { geometry in
            displayPetPhoto(geometry: geometry)
        }
    }

    @ViewBuilder
    private func displayPetPhoto(geometry: GeometryProxy) -> some View {
        if let petPhoto = pet.photo,
           let uiImage = UIImage(data: petPhoto) {

            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height * 0.3)
        } else {
            Image(systemName: "pawprint.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height * 0.2)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            InformationView()
                .environment(previewer.firstPet)
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
