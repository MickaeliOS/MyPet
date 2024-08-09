//
//  ImageExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 09/08/2024.
//

import Foundation
import SwiftUI

extension Image {
    init?(data: Data) {
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
    }
}
