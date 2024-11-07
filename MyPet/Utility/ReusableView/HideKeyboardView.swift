//
//  HideKeyboardView.swift
//  MyPet
//
//  Created by Mickaël Horn on 31/10/2024.
//

import SwiftUI

struct HideKeyboardView: View {
    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
    }
}

#Preview {
    HideKeyboardView()
}
