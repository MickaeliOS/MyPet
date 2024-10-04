//
//  BindingExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 26/08/2024.
//

import Foundation
import SwiftUI

func ?? <Element> (lhs: Binding<Element?>, rhs: Element) -> Binding<Element> {
    Binding {
        lhs.wrappedValue ?? rhs
    } set: { newValue in
        lhs.wrappedValue = newValue
    }
}
