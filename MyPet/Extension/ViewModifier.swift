//
//  ViewModifier.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/10/2024.
//

import Foundation
import SwiftUI

struct CustomTextField: ViewModifier {
    let icon: Image

    func body(content: Content) -> some View {
        HStack {
            icon
                .imageScale(.large)
                .foregroundStyle(.gray)
            content
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color(UIColor.systemGray4), lineWidth: 2)
        }
    }
}

struct ButtonLinearGradient: ViewModifier {
    enum Mode {
        case background
        case foreground
    }

    let mode: Mode

    func body(content: Content) -> some View {
        switch mode {
        case .background:
            content
                .background(LinearGradient.linearBlue)
        case .foreground:
            content
                .foregroundStyle(LinearGradient.linearBlue)
        }
    }
}

struct CustomBackButtonToolBar: ViewModifier {
    let title: String
    let dismiss: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Profil")
                        }
                    }
                }
            }
    }
}
