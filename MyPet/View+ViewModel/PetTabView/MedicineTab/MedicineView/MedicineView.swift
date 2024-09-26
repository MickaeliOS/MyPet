//
//  MedicineView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import SwiftUI

struct MedicineView: View {
    @Environment(Pet.self) var pet
    @State private var isPresentingEditMedicineView = false

    var body: some View {
        VStack {
            HStack {
                CategoryGrayTitleView(text: "Médicaments", systemImage: "pill.fill")
                Spacer()
                OpenModalButton(
                    isPresentingView: $isPresentingEditMedicineView,
                    content: AddMedicineView(),
                    systemImage: "pencil.line"
                )
            }

            if let medicineList = pet.health?.medicine, !medicineList.isEmpty {
                List {
                    ForEach(medicineList) { medicine in
                        MedicineCardView(medicine: medicine)
                    }
                    .onDelete { deleteMedicine(at: $0) }
                }
                .listStyle(.plain)

            } else {
                EmptyListView(
                    emptyListMessage: """
                        La liste est vide, appuyez sur la petite icône située à droite.
                        """,
                    messageFontSize: .title3
                )
            }
        }
    }

    private func deleteMedicine(at offsets: IndexSet) {
        pet.health?.medicine?.remove(atOffsets: offsets)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return MedicineView()
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
