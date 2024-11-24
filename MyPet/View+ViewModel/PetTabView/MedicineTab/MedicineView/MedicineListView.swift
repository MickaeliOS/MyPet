//
//  MedicineListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import SwiftUI
import SwiftData

struct MedicineListView: View {

    // MARK: PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.modelContext) private var modelContext

    @State private var isPresentingEditMedicineView = false
    @State private var path = NavigationPath()
    @State private var viewModel = ViewModel()

    var sortedMedicineList: [Medicine] {
        if let medicineList = pet.medicine, !medicineList.isEmpty {
            let sortedMedicinelist = medicineList.sorted(by: { $0.lastDay > $1.lastDay })

            return sortedMedicinelist
        } else {
            return []
        }
    }

    // MARK: BODY
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
                            viewModel.deleteMedicine(
                                pet: pet,
                                context: modelContext,
                                sortedMedicineList: sortedMedicineList,
                                offsets: $0
                            )
                        }
                    }
                    .listStyle(.plain)
                    .toolbar {
                        EditButton()
                            .environment(\.locale, .init(identifier: "fr"))
                    }
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
                    .foregroundStyle(.blue)
                }
            }
            .sheet(isPresented: $isPresentingEditMedicineView) {
                AddMedicineView()
            }
            .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return TabView {
            NavigationStack {
                MedicineListView()
            }
            .modelContainer(previewer.container)
            .environment(previewer.firstPet)
            .tabItem {
                Label(
                    PetTabView.Category.health.rawValue,
                    systemImage: PetTabView.Category.health.imageName
                )
            }
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
