//
//  UNUserNotificationCenterHelper.swift
//  MyPet
//
//  Created by Mickaël Horn on 13/12/2024.
//

import Foundation
import UserNotifications

protocol UNUserNotificationCenterProtocol {
    func notificationSettings() async -> UNNotificationSettings
    func pendingNotificationRequests() async -> [UNNotificationRequest]
    func add(_ request: UNNotificationRequest) async throws
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    func removeAllPendingNotificationRequests()
}

struct UNUserNotificationCenterHelper: UNUserNotificationCenterProtocol {
    private let center = UNUserNotificationCenter.current()

    func notificationSettings() async -> UNNotificationSettings {
        await center.notificationSettings()
    }

    func pendingNotificationRequests() async -> [UNNotificationRequest] {
        await center.pendingNotificationRequests()
    }

    func add(_ request: UNNotificationRequest) async throws {
        try await center.add(request)
    }

    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func removeAllPendingNotificationRequests() {
        center.removeAllPendingNotificationRequests()
    }
}
