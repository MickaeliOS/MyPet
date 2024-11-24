//
//  EmptyListView.swift
//  MyPet
//
//  Created by Mickaël Horn on 04/09/2024.
//

import SwiftUI

struct EmptyListView: View {

    // MARK: ENUM
    enum Orientation {
        case vertical
        case horizontal
    }

    // MARK: PROPERTY
    private let emptyListMessage: String
    private let messageFontSize: Font
    private let orientation: Orientation

    // MARK: INIT
    init(
        emptyListMessage: String,
        messageFontSize: Font,
        orientation: Orientation = .horizontal
    ) {
        self.emptyListMessage = emptyListMessage
        self.messageFontSize = messageFontSize
        self.orientation = orientation
    }

    // MARK: BODY
    var body: some View {
        switch orientation {
        case .vertical:
            VStack {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 80))

                Text(emptyListMessage)
                    .font(messageFontSize)
                    .lineLimit(nil)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .foregroundStyle(.secondary)
        case .horizontal:
            HStack {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 80))

                Text(emptyListMessage)
                    .font(messageFontSize)
                    .lineLimit(nil)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .foregroundStyle(.secondary)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    EmptyListView(emptyListMessage: "Empty List", messageFontSize: .title2)
}
