//
//  MedicineDetailView.swift
//  MyPet
//
//  Created by Mickaël Horn on 17/09/2024.
//

import SwiftUI

struct MedicineDetailView: View {

    // MARK: - PROPERTY
    @State private var daysLeft: Int?

    let medicine: Medicine
    let medicineDatesGrid = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    // MARK: - BODY
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading) {
                    Image(systemName: medicine.medicineType.imageSystemName)
                        .font(.system(size: 140))
                        .frame(width: 200, height: 200)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)

                    Text("\(medicine.name), \(medicine.dosage)")
                        .font(.largeTitle)
                        .bold()
                }

                VStack(alignment: .leading) {
                    CategoryTitleView(text: "Calendrier", systemImage: "calendar")
                        .padding(.bottom, 5)

                    if medicine.everyDay {
                        Text("Tous les jours")
                            .font(.headline)
                    }

                    if let dates = medicine.dates {
                        let nonNilDates = dates.compactMap { $0.date }
                        let sortedDates = nonNilDates.sorted(by: { $0 < $1 })

                        LazyVGrid(columns: medicineDatesGrid, spacing: 10) {
                            ForEach(sortedDates, id: \.self) { date in
                                Text(date, format: .dateTime.day().month().year())
                                    .padding(5)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blue, lineWidth: 2)
                                    }
                            }
                        }
                    }
                }

                VStack(alignment: .leading) {
                    CategoryTitleView(text: "Horaires de prises", systemImage: "clock.fill")
                        .font(.headline)
                        .padding(.bottom, 5)

                    HStack {
                        ForEach(medicine.takingTimes.indices, id: \.self) { index in
                            let takingTime = medicine.takingTimes[index]

                            Text(takingTime.date, format: .dateTime.hour().minute())
                                .foregroundStyle(.white)
                                .padding()
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .bold()
                        }
                    }
                }

                VStack(alignment: .leading) {
                    CategoryTitleView(text: "Informations complémentaires", systemImage: "info.bubble.fill.rtl")
                        .font(.headline)
                        .padding(.bottom, 5)

                    Text(medicine.additionalInformation ?? "Pas d'informations complémentaires.")

                    if let daysLeft {
                        HStack {
                            Spacer()
                            Text(daysLeft <= 0 ? "Expiré." :
                                    daysLeft == 1 ? "Dernier jour !" :
                                    "Il reste \(daysLeft) jour(s)")
                            .font(.headline)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding([.leading, .trailing, .bottom])
        .onAppear {
            daysLeft = Calendar.current.numberOfDaysBetween(.now,
                                                            and: medicine.lastDay,
                                                            from: medicine.timeZone)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return TabView {
            NavigationStack {
                MedicineDetailView(medicine: Medicine.sampleMedicine)
            }
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
