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

    // MARK: PROPERTY
    @AppStorage("badgeCount") private var badgeCount = 0
    @Environment(\.scenePhase) var scenePhase
    private let notificationHelper = NotificationHelper()
    private let center = UNUserNotificationCenter.current()

    // MARK: BODY
    var body: some Scene {
        WindowGroup {
            PetListView()
                .onAppear {
#if DEBUG
                    //                    center.getPendingNotificationRequests { notifs in
                    //                        notifs.forEach { notif in
                    //                            print("-----------------")
                    //                            print(notif)
                    //                            print("-----------------")
                    //                        }
                    //                    }
                    //                     UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
#endif
                }
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        Task {
                            try? await center.setBadgeCount(0)

                            let pendingNotifications = await center.pendingNotificationRequests()

                            if pendingNotifications.count < badgeCount {
                                if pendingNotifications.count > 0 {
                                    await notificationHelper.reschedulePendingNotifications()
                                }
                            }
                        }
                    }
                }
        }
        .modelContainer(for: Pet.self, isAutosaveEnabled: false)
    }
}
