//
//  LinearGradientExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 03/10/2024.
//

import Foundation
import SwiftUI

extension LinearGradient {
    static var linearBlue: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.cyan]),
            startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/,
            endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/
        )
    }
}
