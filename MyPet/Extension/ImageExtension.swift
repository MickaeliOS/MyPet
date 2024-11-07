//
//  ImageExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import Foundation
import SwiftUI

extension Image {
    init(data: Data?, systemName: String) {
        if let imageData = data, let uiImage = UIImage(data: imageData) {
            self.init(uiImage: uiImage)
        } else {
            self.init(systemName: systemName)
        }
    }
}
