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
    @State private var path = NavigationPath()

    var sortedMedicineList: [Medicine] {
        if let medicineList = pet.medicine, !medicineList.isEmpty {
            let sortedMedicinelist = medicineList.sorted(by: { $0.lastDay > $1.lastDay })

            return sortedMedicinelist
        } else {

            return []
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                if !sortedMedicineList.isEmpty {
                    List {
                        ForEach(sortedMedicineList) { medicine in
                            MedicineCardView(medicine: medicine)
                                .onTapGesture {
                                    path.append(medicine)
                                }
                                .listRowSeparator(.hidden)
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
            .navigationTitle("Médicaments")
            .navigationDestination(for: Medicine.self, destination: { medicine in
                MedicineDetailView(medicine: medicine)
            })
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresentingEditMedicineView = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                    })
                    .font(.title2)
                    .foregroundStyle(LinearGradient.linearBlue)
                }
            }
            .sheet(isPresented: $isPresentingEditMedicineView) {
                AddMedicineView()
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
