//
//  ChartView.swift
//  MyPet
//
//  Created by Mickaël Horn on 24/09/2024.
//

import SwiftUI
import Charts

struct ChartView: View {

    // MARK: PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ViewModel()
    @State private var showWeightHistoryView = false

    private var gradientColor: LinearGradient {
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

    // MARK: BODY
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                HideKeyboardView()

                VStack(alignment: .leading) {
                    if let weights = pet.weights, !weights.isEmpty {
                        Chart {
                            ForEach(weights) { weight in
                                LineMark(
                                    x: .value("Jour", weight.day, unit: .day),
                                    y: .value("Poids", weight.weight)
                                )
                                .symbol(.circle)

                                AreaMark(x: .value("Jour", weight.day, unit: .day), y: .value("Poids", weight.weight))
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

                    HStack {
                        VStack(alignment: .leading) {
                            TextField("Poids en Kg", value: $viewModel.weight, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numbersAndPunctuation)
                                .submitLabel(.done)
                                .onSubmit {
                                    if viewModel.isFormValid {
                                        viewModel.addWeight(for: pet, context: modelContext)
                                    }
                                }

                            DatePicker("Date :", selection: $viewModel.day, displayedComponents: .date)
                        }
                        .frame(width: geometry.size.width * 0.5)

                        Button("Ajouter") {
                            viewModel.addWeight(for: pet, context: modelContext)
                        }
                        .font(.title2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .disabled(!viewModel.isFormValid)
                        .opacity(viewModel.isFormValid ? 1 : 0.4)
                    }
                    .frame(height: geometry.size.height * 0.12)
                    .padding()
                }
                .navigationTitle("Poids")
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
                .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
                    Button("OK") { }
                } message: {
                    Text(viewModel.errorMessage)
                }
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
                ChartView()
            }
            .modelContainer(previewer.container)
            .environment(previewer.firstPet)
            .tabItem {
                Label(
                    PetTabView.Category.charts.rawValue,
                    systemImage: PetTabView.Category.charts.imageName
                )
            }
        }

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
