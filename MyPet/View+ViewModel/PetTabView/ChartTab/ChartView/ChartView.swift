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
    @State private var showWeightHistoryView = false

    var gradientColor: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color.cyan.opacity(0.8),
                    Color.blue.opacity(0.01)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            GeometryReader { geometry in
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                
                VStack(alignment: .leading) {
                    if let weights = pet.weights, !weights.isEmpty {
                        Chart {
                            ForEach(weights) { weight in
                                LineMark(x: .value("Jour", weight.day, unit: .day), y: .value("Poids", weight.weight))
                                    .symbol(.circle)

                                AreaMark(x: .value("Jour", weight.day), y: .value("Poids", weight.weight))
                                    .foregroundStyle(gradientColor)
                            }
                        }
                        .padding([.top, .leading, .trailing])
                        .foregroundStyle(Color.blue)
                        .chartXAxisLabel(position: .bottom, alignment: .center) {
                            Text("Jours")
                                .foregroundStyle(.blue)
                                .font(.headline)
                        }
                        .chartYAxisLabel(position: .leading, alignment: .center) {
                            Text("Poids")
                                .foregroundStyle(.blue)
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
                        .frame(height: geometry.size.height * 0.75)
                    } else {
                        HStack {
                            Image(systemName: "chart.xyaxis.line")
                                .font(.system(size: 80))

                            Text("Aucun poids enregistré, ajoutez-en un juste en bas.")
                                .font(.title2)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(.gray)
                    }

                    Spacer()

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
                        .font(.title2)
                        .disabled(!viewModel.isFormValid)
                        .padding()
                        .background(LinearGradient.linearBlue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                }
                .environment(\.locale, .init(identifier: "fr"))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showWeightHistoryView = true
                        } label: {
                            Image(systemName: "list.bullet.clipboard")
                        }
                    }
                }
                .navigationDestination(isPresented: $showWeightHistoryView) {
                    WeightHistoryView()
                }
                .navigationTitle("Poids")
            }
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
