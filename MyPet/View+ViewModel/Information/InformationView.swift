//
//  InformationView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import SwiftUI

// MARK: - MAIN VIEW
struct InformationView: View {
    @Environment(Pet.self) var pet
    @State private var isPresentingEditInformationView = false
    @State var viewModel = ViewModel()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    GeneralInformation(geometry: geometry, viewModel: viewModel)
                    VariousInformation()
                    IdentificationView(viewModel: viewModel)
                    FavoriteView(viewModel: viewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingEditInformationView = true
                    } label: {
                        Image(systemName: "pencil.line")
                            .font(.title2)
                    }
                }
            }
            .padding([.leading, .trailing, .bottom])
            .sheet(isPresented: $isPresentingEditInformationView) {
                EditInformationView()
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

// MARK: - CHILD VIEWS
struct GeneralInformation: View {
    @Environment(Pet.self) var pet
    let geometry: GeometryProxy
    var viewModel: InformationView.ViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(pet.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)

                Image(viewModel.getGender(gender: pet.gender))
                    .resizable()
                    .frame(width: 30, height: 30)
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
        }
    }
}

struct IdentificationView: View {
    @Environment(Pet.self) var pet
    var viewModel: InformationView.ViewModel

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
            Text(viewModel.defaultValueIfNilOrEmpty(pet.identification?.chipLocation))

            Text("Tatouage")
                .bold()
            Text(viewModel.defaultValueIfNilOrEmpty(pet.identification?.tatoo))

            Text("Localisation Tatouage")
                .bold()
            Text(viewModel.defaultValueIfNilOrEmpty(pet.identification?.tatooLocation))
        }
    }
}

struct VariousInformation: View {
    @Environment(Pet.self) var pet

    var body: some View {
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
    }
}

struct FavoriteView: View {
    @Environment(Pet.self) var pet
    var viewModel: InformationView.ViewModel

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
            Text(viewModel.defaultValueIfNilOrEmpty(pet.favorite?.toy))

            Text("Nourriture")
                .bold()
            Text(viewModel.defaultValueIfNilOrEmpty(pet.favorite?.food))

            Text("Endroit")
                .bold()
            Text(viewModel.defaultValueIfNilOrEmpty(pet.favorite?.place))
        }
    }
}
