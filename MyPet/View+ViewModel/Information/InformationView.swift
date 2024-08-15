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
            VStack(alignment: .leading) {
                if let petPhotoData = pet.photo, let uiImage = UIImage(data: petPhotoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(height: geometry.size.height * 0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Image(systemName: "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.4)
                }

                Text(pet.name)
                    .font(.largeTitle)
                    .padding(.bottom, 5)

                Text(pet.gender.rawValue)
                    .font(.headline)
                Text(pet.type)
                Text(pet.race)
                Text("\(pet.birthdate.dateToStringDMY)")
                Text(pet.color)
                Text(pet.eyeColor)
            }
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
