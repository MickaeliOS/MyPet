//
//  ChartView.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import SwiftUI
import Charts

struct ChartView: View {
    @Environment(Pet.self) var pet
    @State private var viewModel = ViewModel()

    var gradientColor: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color.pink.opacity(0.8),
                    Color.pink.opacity(0.01)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        @Bindable var pet = pet

        GeometryReader { geometry in
            VStack {
                if let weights = pet.weights {
                    Chart {
                        ForEach(weights) { weight in
                            LineMark(x: .value("Jour", weight.day, unit: .day), y: .value("Poids", weight.weight))
                                .symbol(.circle)

                            AreaMark(x: .value("Jour", weight.day), y: .value("Poids", weight.weight))
                                .foregroundStyle(gradientColor)

    //                        PointMark(
    //                            x: .value("Jour", weight.day),
    //                            y: .value("Poids", weight.weight)
    //                        )
    //                        .opacity(0)
    //                        .annotation(position: .overlay,
    //                                    alignment: .bottom,
    //                                    spacing: 10) {
    //                            Text(weight.weight, format: .number)
    //                                .font(.headline)
    //                        }
                        }
                    }
                    .padding()
                    .foregroundStyle(Color.pink)
                    .chartXAxisLabel(position: .bottom, alignment: .center) {
                        Text("Jours")
                            .foregroundStyle(.red)
                            .font(.headline)
                    }
                    .chartYAxisLabel(position: .leading, alignment: .center) {
                        Text("Poids")
                            .foregroundStyle(.red)
                            .font(.headline)
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let poids = value.as(Double.self) {
                                    Text("\(poids.formatted()) Kg")
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.5)
                } else {
                    EmptyListView(
                        emptyListMessage: """
                        La liste est vide, appuyez sur la petite icône située à droite.
                        """,
                        messageFontSize: .title3
                    )
                }

                VStack {
                    HStack {
                        TextField("Poids en Kg", value: $viewModel.weight, format: .number)
                            .textFieldStyle(.roundedBorder)

                        DatePicker("Date", selection: $viewModel.day, displayedComponents: .date)
                            .labelsHidden()
                    }

                    Button("Ajouter") {
                        guard let weight = viewModel.weight else {
                            return
                        }

                        if pet.weights == nil {
                            pet.weights = []
                        }

                        let newWeight = Weight(day: viewModel.day, weight: weight)
                        pet.addWeight(weight: newWeight)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!viewModel.isFormValid)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()

                List {
                    if let weights = pet.weights {
                        ForEach(weights) { weight in
                            HStack {
                                Text(weight.day, format: .dateTime.day().month().year())
                                Spacer()
                                Text("\(weight.weight.formatted()) Kg")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .environment(\.locale, .init(identifier: "fr"))
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NavigationStack {
            ChartView()
        }
        .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
