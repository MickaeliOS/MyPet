//
//  MedicineDetailView.swift
//  MyPet
//
//  Created by Mickaël Horn on 17/09/2024.
//

import SwiftUI

struct MedicineDetailView: View {
    let medicine: Medicine
    @State private var daysLeft: Int?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("LAST DAY : \(medicine.lastDay)")
                Image(systemName: medicine.medicineType.imageSystemName)
                    .font(.system(size: 60))
                    .frame(width: 200, height: 200)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.blue, lineWidth: 5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)

                Text("\(medicine.name), \(medicine.dosage)")
                    .font(.title)
                    .bold()

                if medicine.everyDay {
                    Text("Tous les jours")
                        .font(.headline)
                }

                if let dates = medicine.dates {
                    let nonNilDates = dates.compactMap { $0.date }
                    let sortedDates = nonNilDates.sorted(by: { $0 > $1 })

                    ForEach(sortedDates, id: \.self) { date in
                        Text(date, format: .dateTime.day().month().year())
                    }
                }

                Text("Horaires de prises")
                    .font(.headline)

                HStack {
                    ForEach(medicine.takingTimes.indices, id: \.self) { index in
                        let takingTime = medicine.takingTimes[index]

                        Text(takingTime, format: .dateTime.hour().minute())
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }

                Text(medicine.additionalInformation ?? "Pas d'informations complémentaires.")

                if let daysLeft {
                    HStack {
                        Spacer()
                        Text(daysLeft <= 0 ? "Expiré." :
                                daysLeft == 1 ? "Dernier jour !" :
                                "Il reste \(daysLeft) jour(s)")
                        .font(.callout)
                    }
                }
            }
            .padding()
            .navigationTitle("Détails Médicament")
            .onAppear {
                daysLeft = Calendar.current.numberOfDaysBetween(Calendar.current.startOfDay(for: Date.now),
                                                                and: medicine.lastDay)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack { MedicineDetailView(medicine: Medicine.sampleMedicine) }
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
