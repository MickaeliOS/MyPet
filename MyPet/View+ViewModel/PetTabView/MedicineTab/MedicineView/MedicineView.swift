//
//  MedicineView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import SwiftUI
import SwiftData

struct MedicineView: View {
    @Environment(Pet.self) var pet
    @State private var isPresentingEditMedicineView = false

    var sortedMedicineList: [Medicine] {
        if let medicineList = pet.medicine, !medicineList.isEmpty {
            let sortedMedicinelist = medicineList.sorted(by: { $0.lastDay > $1.lastDay })

            return sortedMedicinelist
        } else {

            return []
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                CategoryGrayTitleView(text: "Médicaments", systemImage: "pill.fill")

                if !sortedMedicineList.isEmpty {
                    List {
                        ForEach(sortedMedicineList) { medicine in
                            NavigationLink(destination: MedicineDetailView(medicine: medicine)) {
                                MedicineCardView(medicine: medicine)
                            }
                        }
                        .onDelete {
                            pet.deleteNotifications(with: sortedMedicineList, offsets: $0)
                            pet.deleteMedicineFromOffSets(with: sortedMedicineList, offsets: $0)
                        }
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    OpenModalButton(
                        isPresentingView: $isPresentingEditMedicineView,
                        content: AddMedicineView(),
                        systemImage: "pencil.line"
                    )
                }
            }
        }
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
