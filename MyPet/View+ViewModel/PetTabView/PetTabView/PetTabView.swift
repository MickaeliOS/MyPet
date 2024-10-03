//
//  PetTabView.swift
//  MyPet
//
//  Created by Mickaël Horn on 19/08/2024.
//

import SwiftUI

struct PetTabView: View {
    @Environment(Pet.self) var pet
    @State private var selectedCategory: Category = .infos
    @Binding var showPetTabView: Bool

    var body: some View {
        TabView {
            InformationListView(showPetTabView: $showPetTabView)
                .tabItem {
                    Label(
                        Category.infos.rawValue,
                        systemImage: Category.infos.imageName
                    )
                }

            MedicineView()
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

#Preview {
    PetTabView(showPetTabView: .constant(false))
        .environment(try? Previewer().firstPet)
}
