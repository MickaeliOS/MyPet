//
//  MedicineCardView.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/09/2024.
//

import SwiftUI

struct MedicineCardView: View {

    // MARK: PROPERTY
    @State private var daysLeft: Int?

    private let calendar = Calendar.current
    private let takingTimesGrid = [
        GridItem(.flexible(minimum: 0), spacing: 0),
        GridItem(.flexible(minimum: 0), spacing: 0),
        GridItem(.flexible(minimum: 0), spacing: 0)
    ]
    let medicine: Medicine

    // MARK: BODY
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(medicine.name), \(medicine.dosage)")

                Spacer()

                Image(systemName: "chevron.right")
                    .padding(.trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title2)
            .bold()
            .foregroundStyle(.white)
            .padding([.top, .leading, .bottom])
            .background(.blue)

            HStack {
                Image(systemName: medicine.medicineType.imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 80.0, height: 80)
                    .foregroundStyle(Color(UIColor.label))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading) {
                    Text(medicine.everyDay ? "Tous les jours" : "Jours spécifiques.")
                        .font(.headline)
                        .foregroundStyle(Color(UIColor.label))

                    if let daysLeft {
                        HStack {
                            Text("Durée : ")
                            Text(daysLeft <= 0 ? "Expiré." :
                                    daysLeft == 1 ? "Dernier jour !" :
                                    "\(daysLeft) jour(s)")
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color(UIColor.label))
                    }

                    LazyVGrid(columns: takingTimesGrid, alignment: .leading) {
                        ForEach(medicine.takingTimes) { takingTime in
                            Text(takingTime.date, format: .dateTime.hour().minute())
                                .padding(5)
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding([.leading, .top])
            }
            .padding([.leading, .trailing, .bottom])
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.blue, lineWidth: 2))
        .onAppear {
            // Adjusting the components in case we changed country, so the
            // interval remains correct.
            var components = DateComponents()
            components.timeZone = medicine.timeZone
            components.calendar = Calendar.current

            guard let startOfDay = components.calendar?.startOfDay(for: .now) else {
                daysLeft = nil
                return
            }

            daysLeft = calendar.numberOfDaysBetween(startOfDay, and: medicine.lastDay)
        }
        .saturation((daysLeft != nil && daysLeft! <= 0) ? 0 : 1)
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationStack {
            MedicineCardView(medicine: Medicine.sampleMedicine)
        }
        .modelContainer(previewer.container)
        .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
