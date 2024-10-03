//
//  OpenModalButton.swift
//  MyPet
//
//  Created by Mickaël Horn on 04/09/2024.
//

import SwiftUI

struct OpenModalButton<Content: View>: View {
    @Binding var isPresentingView: Bool
    let content: Content
    let systemImage: String

    var body: some View {
        Button {
            isPresentingView = true
        } label: {
            Image(systemName: systemImage)
        }
        .sheet(isPresented: $isPresentingView) {
            content
        }
        .font(.title)
        .foregroundStyle(.green)
    }
}

#Preview {
    OpenModalButton(isPresentingView: .constant(false), content: Text("Hello World!"), systemImage: "plus.circle.fill")
}
