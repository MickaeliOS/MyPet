//
//  View.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/10/2024.
//

import Foundation
import SwiftUI

extension View {
    func customTextField(with icon: Image) -> some View {
        modifier(CustomTextField(icon: icon))
    }

    func customBackButtonToolBar(with title: String, dismiss: @escaping () -> Void) -> some View {
        modifier(CustomBackButtonToolBar(title: title, dismiss: dismiss))
    }

    func roundedRectangleShadow() -> some View {
        modifier(RoundedRectangleShadow())
    }

    func wideLinearBlueGradient() -> some View {
        modifier(WideLinearBlueGradient())
    }

    #if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif
}
