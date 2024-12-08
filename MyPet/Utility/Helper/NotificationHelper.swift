//
//  NotificationHelper.swift
//  MyPet
//
//  Created by Mickaël Horn on 06/11/2024.
//

import Foundation
import UserNotifications

struct NotificationHelper {

    // MARK: PROPERTY
    private let center = UNUserNotificationCenter.current()
    private let userDefault = UserDefaults.standard

    // MARK: FUNCTION
    func areNotificationsAuthorized() async -> Bool {
        let settings = await center.notificationSettings()

        if settings.authorizationStatus == .authorized ||
            settings.authorizationStatus == .ephemeral {

            return true
        }

        return false
    }

    func convertPendingNotification() async -> [NotificationTransit] {
        let pendingNotifications = await center.pendingNotificationRequests()

        let transitingNotifications = pendingNotifications.compactMap { request -> NotificationTransit? in
            guard let trigger = request.trigger as? UNCalendarNotificationTrigger,
                  let existingDate = trigger.nextTriggerDate() else {
                return nil
            }

            let existingNotification = NotificationTransit(
                identifier: request.identifier,
                content: request.content,
                date: existingDate,
                trigger: trigger
            )

            return existingNotification
        }

        return transitingNotifications
    }

    func reschedulePendingNotifications() async {
        let notificationsTransit = await convertPendingNotification()
        let sortedNotifications = notificationsTransit.sorted { $0.date < $1.date }

        for sortedNotifications in sortedNotifications {
            // New Content
            let newContent = UNMutableNotificationContent()
            newContent.title = sortedNotifications.content.title
            newContent.body = sortedNotifications.content.body
            newContent.sound = sortedNotifications.content.sound

            // New Trigger
            let newTrigger = sortedNotifications.trigger

            // New ID
            let newID = sortedNotifications.identifier

            // Badge handling
            if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
                badgeCount += 1
                userDefault.set(badgeCount, forKey: "badgeCount")
                newContent.badge = NSNumber(value: badgeCount)
            }

            // Notification is fully constructed with the Request
            let newRequest = UNNotificationRequest(
                identifier: newID,
                content: newContent,
                trigger: newTrigger
            )

            // Adding the Notification in NotificationCenter
            do {
                try await center.add(newRequest)
            } catch {
                if var badgeCount = userDefault.value(forKey: "badgeCount") as? Int {
                    badgeCount -= 1
                    userDefault.set(badgeCount, forKey: "badgeCount")
                }
            }
        }
    }
}

struct NotificationTransit {
    let identifier: String
    let content: UNNotificationContent
    let date: Date
    let trigger: UNCalendarNotificationTrigger
}
