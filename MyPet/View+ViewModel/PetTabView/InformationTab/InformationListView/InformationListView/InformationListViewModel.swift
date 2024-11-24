//
//  InformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 27/08/2024.
//

import Foundation
import UserNotifications
import UIKit
import SwiftUI

extension InformationListView {

    // MARK: - ENUM
    enum InformationListViewModelError: Error {
        case authError

        var description: String {
            switch self {
            case .authError:
                """
                Oups, une erreur est survenue concernant les notifications.
                Essayez de redémarrer l'application et/ou d'activer manuellement
                les notifications dans les paramètres de votre
                téléphone.
                """
            }
        }
    }

    // MARK: - VIEW MODEL
    @Observable
    final class ViewModel {

        // MARK: PROPERTY
        var petPhoto: Image?
        var errorMessage = ""
        var showingAlert = false

        // MARK: FUNCTION
        func getGender(gender: Information.Gender) -> String {
            return gender == .male ? "male" :
            gender == .female ? "female" :
            "hermaphrodite"
        }

        func requestAuthorizationForNotifications() async {
            let center = UNUserNotificationCenter.current()

            do {
                try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                errorMessage = InformationListViewModelError.authError.description
                showingAlert = true
            }
        }

        func setupPetPhoto(with photo: Data?) {
            if let imageData = photo,
               let uiImage = UIImage(data: imageData) {

                petPhoto = Image(uiImage: uiImage)
            } else {
                petPhoto = Image(systemName: "pawprint.fill")
            }
        }
    }
}
