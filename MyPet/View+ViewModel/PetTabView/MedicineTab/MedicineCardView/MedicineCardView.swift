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
    @State private var daysLeft: Int?

    var body: some View {
        HStack {
            Image(systemName: medicine.medicineType.imageSystemName)
                .frame(width: 120, height: 120)
                .font(.largeTitle)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text("\(medicine.name), \(medicine.dosage)")
                    .font(.title2)

                Text(medicine.everyDay ? "Tous les jours" : "Jours spécifiques.")
                    .font(.subheadline)

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

                if let additionalInformation = medicine.additionalInformation {
                    Text(additionalInformation)
                        .lineLimit(1)
                }

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
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            daysLeft = calendar.numberOfDaysBetween(calendar.startOfDay(for: Date.now),
                                                    and: medicine.lastDay)
        }
        .saturation((daysLeft != nil && daysLeft! <= 0) ? 0 : 1)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            MedicineCardView(medicine: Medicine.sampleMedicine)
        }
        .modelContainer(previewer.container)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
