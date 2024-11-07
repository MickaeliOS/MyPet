//
//  MyPetApp.swift
//  MyPet
//
//  Created by Mickaël Horn on 01/08/2024.
//

import SwiftUI
import SwiftData

class AppDelegate: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {

}

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
        var notificationsTransit = await NotificationHelper.convertPendingNotification()
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
//                            }
    }
    }

//    func sortPendingNotificationRequests() {
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//            // Filtrer les requêtes qui ont un trigger avec une date
//            let dateTriggerRequests = requests.filter { request in
//                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
//                    return trigger.nextTriggerDate() != nil
//                }
//
//                return false
//            }
//
//            // Trier les requêtes par la date de déclenchement
//            let sortedRequests = dateTriggerRequests.sorted { (request1, request2) -> Bool in
//                guard let date1 = (request1.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate(),
//                      let date2 = (request2.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() else {
//                    return false // Si aucune date n'est trouvée, ne pas trier cette requête
//                }
//
//                return date1 < date2
//            }
//
//            // Maintenant sortedRequests contient vos requêtes triées par triggerDate
//            print("Sorted requests:")
//            sortedRequests.forEach { request in
//                if let triggerDate = (request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() {
//                    print("\(request.identifier): \(triggerDate)")
//                }
//            }
//        }
//    }

//    func rescheduleNotifications(with requests: [UNNotificationRequest]) {
//        center.removeAllPendingNotificationRequests()
//
//        requests.forEach { request in
//            // Setting up the Notification's Content
//            let content = UNMutableNotificationContent()
//            content.title = request.content.title
//            content.body = request.content.body
//            content.sound = request.content.sound
//
//            // Trigger's creation
//            guard let trigger = request.trigger as? UNCalendarNotificationTrigger,
//                  let date = trigger.nextTriggerDate() else {
//                return
//            }
//
//            let triggerDate = Calendar.current.datecom
//            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
//
//
//            // Notification is fully constructed with the Request
//            let id = UUID().uuidString
//            let request = UNNotificationRequest(
//                identifier: id,
//                content: content,
//                trigger: trigger
//            )
//
//            // Adding the Notification in NotificationCenter
//            UNUserNotificationCenter.current().add(request)
//            notificationIDs.append(id)
//    }
}
