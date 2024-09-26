//
//  AddMedicineView.swift
//  MyPet
//
//  Created by Mickaël Horn on 04/09/2024.
//

import SwiftUI

struct AddMedicineView: View {
    @Environment(Pet.self) var pet
    @Environment(\.dismiss) var dismiss

    @FocusState private var durationIsFocused
    @State private var viewModel = ViewModel()
    @State private var isDatePickerPresented = false

    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            VStack {
                Form {
                    Section("Informations") {
                        TextField("Nom", text: $viewModel.medicineName)
                        TextField("Dosage, ex: 4ml", text: $viewModel.medicineDosage)
                        TextField("Informations complémentaires", text: $viewModel.additionalInformations)
                    }

                    Section("Type de médicament") {
                        MedicineTypeView(selectedMedicineType: $viewModel.selectedMedicineType)
                    }

                    Section("Fréquence") {
                        Toggle("Tous les jours", isOn: $viewModel.everyDay)

                        if viewModel.everyDay {
                            TextField("Combien de jours ?", value: $viewModel.duration, format: .number)
                                .keyboardType(.numberPad)
                                .focused($durationIsFocused)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            durationIsFocused = false
                                        }
                                    }
                                }
                        } else {
                            Button {
                                isDatePickerPresented = true
                            } label: {
                                Text("Sélectionner les jours (\(viewModel.medicineDates.count) sélectionnés)")
                            }
                            .sheet(isPresented: $isDatePickerPresented) {
                                VStack {
                                    Text("Sélectionner les jours")
                                        .font(.headline)
                                        .padding()

                                    MultiDatePicker("Sélectionnez vos jours", selection: $viewModel.medicineDates)
                                        .padding()

                                    Button("Fermer") {
                                        isDatePickerPresented = false
                                    }
                                    .padding()
                                }
                            }
                        }
                    }

                    Section("Horaires de prise") {
                        ForEach(viewModel.takingTimes.indices, id: \.self) { index in
                            HStack {
                                if index != 0 {
                                    Button {
                                        viewModel.takingTimes.remove(at: index)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }

                                DatePicker(
                                    "Horaire \(index + 1)",
                                    selection: $viewModel.takingTimes[index],
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                            }
                            .frame(height: 50)
                        }
                    }

                    Button {
                        viewModel.takingTimes.append(Date())
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Ajouter une horaire")
                        }
                    }
                }
                .navigationTitle("Ajouter un médicament")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Sauvegarder") {
                            if let medicine = viewModel.createMedicine() {
                                pet.medicine?.append(medicine)
                                dismiss()
                            }
                        }
                    }
                }
                .alert("Erreur", isPresented: $viewModel.showingAlert) {
                    Button("OK") { }
                } message: {
                    Text(viewModel.errorMessage)
                }
            }
        }
    }
}

struct MedicineTypeView: View {
    @Binding var selectedMedicineType: Medicine.MedicineCategory

    var body: some View {
        HStack {
            ForEach(Medicine.MedicineCategory.allCases, id: \.self) { medicine in
                Button {
                    selectedMedicineType = medicine
                } label: {
                    Image(systemName: medicine.rawValue)
                        .font(.largeTitle)
                }
                .frame(width: 100, height: 100)
                .background(selectedMedicineType == medicine ? Color.blue : Color.clear)
                .foregroundStyle(selectedMedicineType == medicine ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return AddMedicineView()
            .environment(previewer.firstPet)

    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
