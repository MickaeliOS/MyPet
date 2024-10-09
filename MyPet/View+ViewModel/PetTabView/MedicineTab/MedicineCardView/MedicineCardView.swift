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
        VStack(alignment: .leading) {
            Text("\(medicine.name), \(medicine.dosage)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
                .padding([.top, .leading])

            HStack {
                Image(systemName: medicine.medicineType.imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 80.0, height: 80)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading) {
                    Text(medicine.everyDay ? "Tous les jours" : "Jours spécifiques.")
                        .font(.headline)
                        .foregroundStyle(.white)

                    HStack {
                        ForEach(medicine.takingTimes) { takingTime in
                            Text(takingTime.date, format: .dateTime.hour().minute())
                                .padding(5)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(LinearGradient.linearBlue)
                        }
                    }
                }
                .padding(.leading)

                Spacer()

                if let daysLeft {
                    Text(daysLeft <= 0 ? "Expiré." :
                            daysLeft == 1 ? "Dernier jour !" :
                            "\(daysLeft) jour(s)")
                    .font(.caption)
                    .foregroundStyle(.white)
                }
            }
            .padding([.leading, .trailing, .bottom])
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(LinearGradient.linearBlue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
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
