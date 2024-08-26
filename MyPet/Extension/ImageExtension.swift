//
//  ImageExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import Foundation
import SwiftUI

extension Image {
    init?(data: Data?) {
        if let imageData = data, let uiImage = UIImage(data: imageData) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
    }
}
