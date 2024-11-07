//
//  EditListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 04/09/2024.
//

import SwiftUI

struct EditListView: View {

    // MARK: - PROPERTY
    @State var viewModel: ViewModel
    @State private var scrollToEnd = false
    @Binding var list: [String]

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                ZStack {
                    HideKeyboardView()

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
                                        // Minus Button + TextField
                                        HStack {
                                            Button {
                                                if list.indices.contains(index) {
                                                    list.remove(at: index)
                                                }
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                            }
                                            .font(.title3)
                                            .padding(5)

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
                        .padding([.leading, .trailing, .bottom])
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

// MARK: - PREVIEW
#Preview {
    do {
        let previewer = try Previewer()

        return EditListView(
            viewModel: EditListView.ViewModel(dataType: .allergy), list: .constant([])
        )
        .environment(previewer.firstPet)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
