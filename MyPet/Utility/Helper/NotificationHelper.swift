//
//  NotificationHelper.swift
//  MyPet
//
//  Created by Mickaël Horn on 06/11/2024.
//

import Foundation
import UserNotifications

struct NotificationHelper {
    private let center = UNUserNotificationCenter.current()

    static func convertPendingNotification() async -> [NotificationTransit] {
        let pendingNotifications = await UNUserNotificationCenter.current().pendingNotificationRequests()

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
}

struct NotificationTransit {
    let identifier: String
    let content: UNNotificationContent
    let date: Date
    let trigger: UNCalendarNotificationTrigger
}
