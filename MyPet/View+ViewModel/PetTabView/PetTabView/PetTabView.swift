//
//  PetTabView.swift
//  MyPet
//
//  Created by Mickaël Horn on 19/08/2024.
//

import SwiftUI

struct PetTabView: View {

    // MARK: - PROPERTY
    @Environment(Pet.self) private var pet
    @Binding var showPetTabView: Bool

    // MARK: BODY
    var body: some View {
        TabView {
            InformationListView(showPetTabView: $showPetTabView)
                .tabItem {
                    Label(
                        Category.infos.rawValue,
                        systemImage: Category.infos.imageName
                    )
                }

            MedicineListView()
                .tabItem {
                    Label(
                        Category.health.rawValue,
                        systemImage: Category.health.imageName
                    )
                }

            VeterinarianView()
                .tabItem {
                    Label(
                        Category.veterinarian.rawValue,
                        systemImage: Category.veterinarian.imageName
                    )
                }

            ChartView()
                .tabItem {
                    Label(
                        Category.charts.rawValue,
                        systemImage: Category.charts.imageName
                    )
                }
        }
    }
}

// MARK: EXTENSION
extension PetTabView {
    enum Category: String, CaseIterable {
        case infos = "Infos"
        case health = "Santé"
        case veterinarian = "Vétérinaire"
        case charts = "Suivi"

        var imageName: String {
            switch self {
            case .infos:
                return "list.bullet.clipboard"
            case .health:
                return "heart"
            case .veterinarian:
                return "cross.case.fill"
            case .charts:
                return "chart.xyaxis.line"
            }
        }
    }
}

// MARK: PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return
            PetTabView(showPetTabView: .constant(true))
                .environment(previewer.firstPet)
                .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
