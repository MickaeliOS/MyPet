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

    func buttonLinearGradient(for mode: ButtonLinearGradient.Mode) -> some View {
        modifier(ButtonLinearGradient(mode: mode))
    }

    func customBackButtonToolBar(with title: String, dismiss: @escaping () -> Void) -> some View {
        modifier(CustomBackButtonToolBar(title: title, dismiss: dismiss))
    }
}
