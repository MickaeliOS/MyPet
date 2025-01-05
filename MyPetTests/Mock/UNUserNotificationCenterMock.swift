//
//  UNUserNotificationCenterMock.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 13/12/2024.
//

import Foundation
import UserNotifications
@testable import MyPet

final class UNUserNotificationCenterMock: UNUserNotificationCenterProtocol {
    var pendingNotificationRequests: [UNNotificationRequest] = []

    func notificationSettings() async -> UNNotificationSettings {
        await UNUserNotificationCenter.current().notificationSettings()
    }

    func pendingNotificationRequests() async -> [UNNotificationRequest] {
        pendingNotificationRequests
    }

    func add(_ request: UNNotificationRequest) async throws {
        let hasValidContent = !request.content.title.isEmpty || !request.content.body.isEmpty

        if !request.identifier.isEmpty && hasValidContent && request.trigger != nil {
            pendingNotificationRequests.append(request)
        }
    }

    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        pendingNotificationRequests = pendingNotificationRequests.filter { request in
            !identifiers.contains(request.identifier)
        }
    }

    func removeAllPendingNotificationRequests() {
        pendingNotificationRequests = []
    }
}
