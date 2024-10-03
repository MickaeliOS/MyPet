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
                ScrollView {
                    VStack(alignment: .leading) {
                        CategoryGrayTitleView(
                            text: viewModel.dataType.rawValue,
                            systemImage: viewModel.dataType.imageName
                        )

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

                                if list.indices.contains(index) {
                                    TextField(
                                        viewModel.dataType == .allergy ?
                                        "Allergie \(index + 1)" :
                                        "Intolérance \(index + 1)",
                                        text: $list[index]
                                    )
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.vertical, 4)
                                }
                            }
                        }

                        // Create a new TextField
                        Button {
                            list.append("")
                            scrollToEnd = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text(
                                    viewModel.dataType == .allergy ?
                                    "Ajouter une allergie" :
                                    "Ajouter une intolérance"
                                )
                            }
                            .font(.title3)
                        }
                        .id("addButton")
                    }
                    .padding()
                    .onChange(of: scrollToEnd) {
                        if scrollToEnd {
                            withAnimation {
                                scrollViewProxy.scrollTo("addButton", anchor: .center)
                            }
                            scrollToEnd = false
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
