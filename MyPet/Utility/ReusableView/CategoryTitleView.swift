//
//  CategoryTitleView.swift
//  MyPet
//
//  Created by Mickaël Horn on 02/09/2024.
//

import SwiftUI

struct CategoryTitleView<S: ShapeStyle>: View {

    // MARK: PROPERTY
    let text: String
    let systemImage: String
    var foregroundStyle: S

    // MARK: INIT
    init(text: String, systemImage: String, foregroundStyle: S = .blue) {
        self.text = text
        self.systemImage = systemImage
        self.foregroundStyle = foregroundStyle
    }

    // MARK: BODY
    var body: some View {
        Label {
            Text(text)
        } icon: {
            Image(systemName: systemImage)
        }
        .font(.title2)
        .foregroundStyle(foregroundStyle)
    }
}

// MARK: - PREVIEW
#Preview {
    CategoryTitleView(text: "Identification", systemImage: "cpu")
}
