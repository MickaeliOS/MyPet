//
//  ThickDividerView.swift
//  MyPet
//
//  Created by Mickaël Horn on 15/08/2024.
//

import SwiftUI

struct ThickDividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.gray)
            .padding(.bottom)
    }
}

#Preview {
    ThickDividerView()
}
