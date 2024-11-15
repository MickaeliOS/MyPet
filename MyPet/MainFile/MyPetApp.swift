//
//  MyPetApp.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/08/2024.
//

import SwiftUI
import SwiftData

@main
struct MyApp: App {
    @AppStorage("badgeCount") private var badgeCount = 0
    @Environment(\.scenePhase) var scenePhase

    private let center = UNUserNotificationCenter.current()

    var body: some Scene {
        WindowGroup {
            PetListView()
                .onAppear {
#if DEBUG
                    // UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
#endif
                }
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        Task {
                            let pendingNotifications = await center.pendingNotificationRequests()

                            if pendingNotifications.count < badgeCount {
                                try? await center.setBadgeCount(0)
                                badgeCount = 0

                                if pendingNotifications.count > 0 {
                                    await reschedulePendingNotifications(pendingNotifications: pendingNotifications)
                                }
                            }
                        }
                    }
                }
        }
        .modelContainer(for: [Pet.self])
    }

    private func reschedulePendingNotifications(pendingNotifications: [UNNotificationRequest]) async {
        let notificationsTransit = await NotificationHelper.convertPendingNotification()
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
            badgeCount += 1
            newContent.badge = NSNumber(value: badgeCount)

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
                badgeCount -= 1
                newContent.badge = NSNumber(value: badgeCount)
            }
        }
    }
}
