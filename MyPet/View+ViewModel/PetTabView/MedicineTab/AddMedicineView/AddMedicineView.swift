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

    @State private var viewModel = ViewModel()
    @State private var scrollToEnd = false

    var body: some View {
        @Bindable var pet = pet

        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ZStack {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                hideKeyboard()
                            }
                        
                        VStack(alignment: .leading, spacing: 30) {
                            MedicineMainInformationView(addMedicineViewModel: $viewModel)
                            MedicineTypeView(selectedMedicineType: $viewModel.selectedMedicineType)
                            MedicineFrequencyView(addMedicineViewModel: $viewModel)
                            MedicineSchedulesView(addMedicineViewModel: $viewModel, scrollToEnd: $scrollToEnd)
                        }
                        .frame(alignment: .topLeading)
                        .navigationTitle("Ajouter un médicament")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Sauvegarder") {
                                    if var medicine = viewModel.createMedicineFlow() {
                                        if pet.medicine == nil {
                                            pet.medicine = []
                                        }

//                                        viewModel.handleNotifications(medicine: medicine, petName: pet.information.name)
                                        viewModel.scheduleNotifications(medicine: medicine, petName: pet.information.name)
                                        medicine.notificationIDs = viewModel.notificationIDs
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
                .onChange(of: scrollToEnd) {
                    if scrollToEnd {
                        withAnimation {
                            scrollViewProxy.scrollTo("addButton", anchor: .center)
                        }
                        scrollToEnd = false
                    }
                }
            }
        }
    }
}

struct MedicineMainInformationView: View {
    @Binding var addMedicineViewModel: AddMedicineView.ViewModel
    @FocusState private var focusedField: AddMedicineView.FocusedField?

    var body: some View {
        VStack(alignment: .leading) {
            CategoryTitleView(text: "Informations", systemImage: "info.square.fill")
                .padding([.top, .leading])

            VStack {
                TextField("Nom", text: $addMedicineViewModel.medicineName)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .customTextField(with: Image(systemName: "person.fill"))

                TextField("Dosage, ex: 4ml", text: $addMedicineViewModel.medicineDosage)
                    .focused($focusedField, equals: .dosage)
                    .submitLabel(.next)
                    .customTextField(with: Image(systemName: "lines.measurement.vertical"))

                TextField("Informations complémentaires", text: $addMedicineViewModel.additionalInformations)
                    .focused($focusedField, equals: .additionalInformation)
                    .submitLabel(.done)
                    .customTextField(with: Image(systemName: "info.bubble.fill.rtl"))
            }
            .padding([.leading, .trailing])
            .onSubmit {
                if focusedField != .additionalInformation {
                    focusedField = addMedicineViewModel.nextField(focusedField: focusedField ?? .name)
                }
            }
        }
    }
}

struct MedicineTypeView: View {
    @Binding var selectedMedicineType: Medicine.MedicineType

    var body: some View {
        VStack(alignment: .leading) {
            CategoryTitleView(
                text: "Type de médicament",
                systemImage: "pills.circle.fill"
            )
            .padding([.leading, .trailing, .bottom])

            HStack {
                ForEach(Medicine.MedicineType.allCases, id: \.self) { medicine in
                    Button {
                        selectedMedicineType = medicine
                    } label: {
                        Image(systemName: medicine.imageSystemName)
                            .font(.largeTitle)
                    }
                    .frame(width: 100, height: 100)
                    .background(
                        Group {
                            if selectedMedicineType == medicine {
                                AnyView(LinearGradient.linearBlue)
                            } else {
                                AnyView(Color.clear)
                            }
                        }
                    )
                    .foregroundStyle(selectedMedicineType == medicine ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
        }
    }
}

struct MedicineFrequencyView: View {
    @State private var isDatePickerPresented = false
    @FocusState private var durationIsFocused
    @Binding var addMedicineViewModel: AddMedicineView.ViewModel

    var body: some View {
        VStack(alignment: .leading) {
            CategoryTitleView(
                text: "Fréquence",
                systemImage: "calendar.circle.fill"
            )
            .padding([.leading, .trailing])

            VStack(alignment: .leading) {
                Toggle("Tous les jours", isOn: $addMedicineViewModel.everyDay)

                if addMedicineViewModel.everyDay {
                    TextField("Combien de jours ?", value: $addMedicineViewModel.duration, format: .number)
                        .customTextField(with: Image(systemName: "calendar"))
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
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Sélectionner les jours (\(addMedicineViewModel.multiDatePickerDateSet.count) sélectionnés)")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient.linearBlue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .sheet(isPresented: $isDatePickerPresented) {
                        VStack {
                            Text("Sélectionner les jours")
                                .font(.headline)
                                .padding()

                            MultiDatePicker("Sélectionnez vos jours", selection: $addMedicineViewModel.multiDatePickerDateSet)
                                .padding()

                            Button("Fermer") {
                                isDatePickerPresented = false
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(.white)
                            .padding()
                        }
                        .environment(\.locale, .init(identifier: "fr"))
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
}

struct MedicineSchedulesView: View {
    @Binding var addMedicineViewModel: AddMedicineView.ViewModel
    @Binding var scrollToEnd: Bool

    var body: some View {
        VStack(alignment: .leading) {
            CategoryTitleView(
                text: "Horaires de prises",
                systemImage: "clock.fill"
            )
            .padding([.leading])

            VStack(alignment: .leading) {
                ForEach(addMedicineViewModel.takingTimes.indices, id: \.self) { index in
                    HStack {
                        if index != 0 {
                            Button {
                                addMedicineViewModel.takingTimes.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }

                        DatePicker(
                            "Horaire \(index + 1)",
                            selection: $addMedicineViewModel.takingTimes[index].date,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }

                Button {
                    addMedicineViewModel.takingTimes.append(.init(date: .now))
                    scrollToEnd = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter une horaire")
                    }
                }
                .id("addButton")
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient.linearBlue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding([.leading, .trailing])
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
