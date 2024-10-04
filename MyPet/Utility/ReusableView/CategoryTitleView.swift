//
//  CategoryTitleView.swift
//  MyPet
//
//  Created by Mickaël Horn on 02/09/2024.
//

import SwiftUI

struct CategoryTitleView<S: ShapeStyle>: View {
    let text: String
    let systemImage: String
    var foregroundStyle: S

    init(text: String, systemImage: String, foregroundStyle: S = LinearGradient.linearBlue) {
        self.text = text
        self.systemImage = systemImage
        self.foregroundStyle = foregroundStyle
    }

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

#Preview {
    CategoryTitleView(text: "Identification", systemImage: "cpu")
}
