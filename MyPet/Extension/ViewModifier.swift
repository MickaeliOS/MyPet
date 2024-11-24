//
//  ViewModifier.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/10/2024.
//

import Foundation
import SwiftUI

struct CustomTextField: ViewModifier {

    // MARK: PROPERTY
    let icon: Image

    // MARK: BODY
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

struct CustomBackButtonToolBar: ViewModifier {

    // MARK: PROPERTY
    let title: String
    let dismiss: () -> Void

    // MARK: BODY
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .bold()

                            Text(title)
                        }
                    }
                }
            }
    }
}

struct RoundedRectangleShadow: ViewModifier {

    // MARK: BODY
    func body(content: Content) -> some View {
        content
            .background(Color(UIColor.systemBackground))
            .foregroundStyle(Color(UIColor.label))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 10)
    }
}

struct WideLinearBlueGradient: ViewModifier {

    // MARK: BODY
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(LinearGradient.linearBlue)
    }
}
