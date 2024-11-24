//
//  PhotoPickerCenter.swift
//  MyPet
//
//  Created by Mickaël Horn on 30/10/2024.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
final class PhotoPickerCenter {

    // MARK: ENUM
    enum PhotoPickerCenterError: Error {
        case cannotLoadPhoto

        var description: String {
            switch self {
            case .cannotLoadPhoto:
                "Il semble y avoir un problème avec votre photo, essayez-en une autre."
            }
        }
    }

    // MARK: PROPERTY
    var item: PhotosPickerItem?
    var image: Image?
    var showingAlert = false
    var errorMessage = ""

    // MARK: FUNCTION
    func setupPhoto() async -> Data? {
        if let imageData = try? await item?.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: imageData) {

            image = Image(uiImage: uiImage)
            return imageData
        } else {
            errorMessage = PhotoPickerCenterError.cannotLoadPhoto.description
            showingAlert = true
            return nil
        }
    }
}
