//
//  MedicineCardView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import SwiftUI

struct MedicineCardView: View {
    let medicine: Medicine
    let calendar = Calendar.current

    var body: some View {
        HStack {
            Image(systemName: medicine.medicineTypeImageName.rawValue)
                .frame(width: 120, height: 120)
                .font(.largeTitle)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text("\(medicine.name), \(medicine.dosage)")
                    .font(.title)

                Text(medicine.everyDay ? "Tous les jours" : "Jours spécifiques.")
                    .font(.headline)

                HStack {
                    ForEach(medicine.takingTimes, id: \.self) { takingTime in
                        Text(takingTime, format: .dateTime.hour().minute())
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }

                if let additionalInformation = medicine.additionalInformation {
                    Text(additionalInformation)
                }

                if let lastDay = medicine.lastDay,
                   let daysLeft = calendar.numberOfDaysBetween(
                    calendar.startOfDay(for: Date.now),
                    and: lastDay
                   ) {
                    HStack {
                        Spacer()
                        Text(daysLeft <= 0 ? "Expiré." :
                             daysLeft == 1 ? "Dernier jour !" :
                             "Il reste \(daysLeft) jour(s)")
                            .font(.callout)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            MedicineCardView(
                medicine: Medicine(
                    name: "Medicine",
                    dosage: "10mg",
                    medicineTypeImageName: .bottle,
                    everyDay: true,
                    takingTimes: [
                        Date(),
                        Date()
                    ],
                    dates: nil
                )
            )
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
