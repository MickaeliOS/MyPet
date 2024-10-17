//
//  EditListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 04/09/2024.
//

import SwiftUI

struct EditListView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var list: [String]
    @State var viewModel: ViewModel
    @State private var scrollToEnd = false
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }

                    VStack(alignment: .leading) {
                        HStack {
                            CategoryTitleView(
                                text: viewModel.dataType.rawValue,
                                systemImage: viewModel.dataType.imageName
                            )
                            .padding(.leading)
                            
                            Button {
                                list.append("")
                                scrollToEnd = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                }
                                .font(.title3)
                                .padding(.trailing)
                            }
                            .id("addButton")
                        }
                        
                        VStack {
                            if list.isEmpty {
                                EmptyListView(
                                    emptyListMessage: "La liste est vide, appuyez sur l'icône +",
                                    messageFontSize: .title2
                                )
                            } else {
                                ScrollView {
                                    
                                    ForEach(list.indices, id: \.self) { index in
                                        // Minus Button + Allergy TextField
                                        HStack {
                                            Button {
                                                if list.indices.contains(index) {
                                                    list.remove(at: index)
                                                }
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                            }
                                            .font(.title3)
                                            .padding()

                                            if list.indices.contains(index) {
                                                TextField(
                                                    viewModel.dataType == .allergy ?
                                                    "Allergie \(index + 1)" :
                                                        "Intolérance \(index + 1)",
                                                    text: $list[index]
                                                )
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                            }
                                        }
                                        .id(index)
                                    }
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        .onChange(of: scrollToEnd) {
                            if scrollToEnd {
                                withAnimation {
                                    scrollViewProxy.scrollTo(list.indices.last, anchor: .bottom)
                                }
                                scrollToEnd = false
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return EditListView(
            list: .constant([]),
            viewModel: EditListView.ViewModel(dataType: .allergy)
        )
        .environment(previewer.firstPet)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
