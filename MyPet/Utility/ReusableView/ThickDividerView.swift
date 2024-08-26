//
//  ThickDividerView.swift
//  MyPet
//
//  Created by Mickaël Horn on 15/08/2024.
//

import SwiftUI

enum Orientation {
    case vertical
    case horizontal
}

struct ThickDividerView: View {
    let orientation: Orientation

    var body: some View {
        Rectangle()
            .frame(width: orientation == .vertical ? 2 : nil,
                   height: orientation == .horizontal ? 2 : nil)
    }
}

#Preview {
    ThickDividerView(orientation: .vertical)
}
