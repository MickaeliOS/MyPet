//
//  InformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import SwiftUI

struct InformationView: View {
    @Environment(Pet.self) var pet
    @State private var isPresentingEditInformationView = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text(pet.name)
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 5)

                        Image(pet.gender == .male ? "male" : pet.gender == .female ? "female" : "hermaphrodite")
                            .resizable()
                            .frame(width: 30, height: 30)

                        Spacer()

                        Button {
                            isPresentingEditInformationView = true
                        } label: {
                            Image(systemName: "pencil.line")
                        }
                    }

                    HStack {
                        Text(pet.type)
                            .padding(.trailing)

                        ThickDividerView(orientation: .vertical)

                        Text(pet.race)
                            .padding([.leading, .trailing])

                        ThickDividerView(orientation: .vertical)

                        Text("\(pet.birthdate.dateToStringDMY)")
                            .padding(.leading)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.1)
                    .padding([.top, .bottom])

                    VStack(alignment: .leading, spacing: 10) {
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

                    IdentificationView()
                    FavoriteView()
                }
            }
            .padding([.leading, .trailing, .bottom])
            .sheet(isPresented: $isPresentingEditInformationView) {
                EditInformationView()
            }
        }
    }
}

struct IdentificationView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text("Identification")
            } icon: {
                Image(systemName: "cpu")
            }
            .font(.title2)
            .foregroundStyle(.gray)
            .padding()

            Text("Puce")
                .bold()
            Text(pet.identification?.chip.map { "\($0)" } ?? "Non renseigné")

            Text("Localisation Puce")
                .bold()
            Text(pet.identification?.chipLocation ?? "Non renseigné")

            Text("Tatouage")
                .bold()
            Text(pet.identification?.tatoo ?? "Non renseigné")

            Text("Localisation Tatouage")
                .bold()
            Text(pet.identification?.tatooLocation ?? "Non renseigné")
        }
    }
}

struct FavoriteView: View {
    @Environment(Pet.self) var pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text("Favoris")
            } icon: {
                Image(systemName: "star.fill")
            }
            .font(.title2)
            .foregroundStyle(.gray)
            .padding()

            Text("Jouet")
                .bold()
            Text(pet.favorite?.toy ?? "Non renseigné")

            Text("Nourriture")
                .bold()
            Text(pet.favorite?.food ?? "Non renseigné")

            Text("Endroit")
                .bold()
            Text(pet.favorite?.place ?? "Non renseigné")
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
