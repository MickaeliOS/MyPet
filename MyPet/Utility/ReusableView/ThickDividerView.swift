//
//  ThickDividerView.swift
//  MyPet
//
//  Created by Mickaël Horn on 15/08/2024.
//

import SwiftUI

struct ThickDividerView: View {

    // MARK: ENUM
    enum Orientation {
        case vertical
        case horizontal
    }

    // MARK: PROPERTY
    let orientation: Orientation

    // MARK: BODY
    var body: some View {
        Rectangle()
            .frame(width: orientation == .vertical ? 2 : nil,
                   height: orientation == .horizontal ? 2 : nil)
    }
}

// MARK: - PREVIEW
#Preview {
    ThickDividerView(orientation: .vertical)
}
