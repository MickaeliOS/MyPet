//
//  EmptyListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 04/09/2024.
//

import SwiftUI

struct EmptyListView: View {
    let emptyListMessage: String
    let messageFontSize: Font

    var body: some View {
        VStack {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 80))

            Text(emptyListMessage)
                .font(messageFontSize)
                .lineLimit(0)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundStyle(.secondary)
    }
}

#Preview {
    EmptyListView(emptyListMessage: "Empty List", messageFontSize: .title2)
}
