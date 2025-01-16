//
//  AddMedicineView.swift
//  MyPet
//
//  Created by Mickaël Horn on 04/09/2024.
//

import SwiftUI

struct AddMedicineView: View {
    
    // MARK: PROPERTY
    @Environment(Pet.self) private var pet
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel = ViewModel(notificationHelper: NotificationHelper())
    @State private var scrollToEnd = false
    
    private let center = UNUserNotificationCenter.current()
    private let notificationHelper = NotificationHelper()
    
    // MARK: BODY
    var body: some View {
        @Bindable var pet = pet
        
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ZStack {
                        HideKeyboardView()
                        
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
                                    let medicineCopy = pet.medicine
                                    
                                    if var medicine = viewModel.createMedicineFlow() {
                                        if pet.medicine == nil {
                                            pet.medicine = []
                                        }
                                        
                                        Task {
                                            if await notificationHelper.areNotificationsAuthorized() {
                                                await viewModel.scheduleNotificationsFlow(
                                                    medicine: medicine,
                                                    petName: pet.information.name
                                                )
                                                
                                                medicine.notificationIDs = viewModel.notificationIDs
                                            }
                                            
                                            pet.medicine?.append(medicine)
                                            
                                            if viewModel.savePet(context: modelContext) {
                                                dismiss()
                                            } else {
                                                viewModel.deleteNotifications()
                                                pet.medicine = medicineCopy
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .alert("Une erreur est survenue.", isPresented: $viewModel.showingAlert) {
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

// MARK: - CHILD VIEW
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
                                AnyView(Color.blue)
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
                            if durationIsFocused {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("terminé") {
                                        durationIsFocused = false
                                    }
                                }
                            }
                        }
                } else {
                    Button {
                        isDatePickerPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Sélectionner les jours (\(addMedicineViewModel.multiDatePickerDateSet.count))")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top)
                    .sheet(isPresented: $isDatePickerPresented) {
                        VStack {
                            Text("Sélectionner les jours")
                                .font(.headline)
                                .padding()
                            
                            MultiDatePicker(
                                "Sélectionnez vos jours",
                                selection: $addMedicineViewModel.multiDatePickerDateSet
                            )
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
                        .environment(\.locale, .init(identifier: Locale.preferredLanguages[0]))
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
                                    .font(.title)
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
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding([.top, .bottom])
            }
            .padding([.leading, .trailing])
        }
    }
}

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()
        
        return AddMedicineView()
            .modelContainer(previewer.container)
            .environment(previewer.firstPet)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
