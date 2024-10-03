//
//  InformationViewModel.swift
//  MyPet
//
//  Created by Mickaël Horn on 27/08/2024.
//

import Foundation
import UserNotifications

extension InformationListView {

    @Observable
    final class ViewModel {
        var errorMessage = ""
        var showingAlert = false
        var gaveAuthorization = false

        func getGender(gender: Information.Gender) -> String {
            return gender == .male ? "male" :
                   gender == .female ? "female" :
                   "hermaphrodite"
        }

        func requestAuthorizationForNotifications() {
            UNUserNotificationCenter.current().requestAuthorization(options: [
                .alert,
                .badge,
                .sound
            ]) { [weak self] success, _ in
                if success {
                    self?.gaveAuthorization = true
                } else {
                    self?.errorMessage = """
                    Oups, une erreur est survenue concernant les
                    notifications, essayez de redémarrer l'application.
                    """
                    self?.showingAlert = true
                }
            }
        }
    }
}
