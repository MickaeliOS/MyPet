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
    var body: some Scene {
        WindowGroup {
            PetListView()
                .onAppear {
                    #if DEBUG
//                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

                    let center = UNUserNotificationCenter.current()
                    center.getPendingNotificationRequests(completionHandler: { requests in
                        for request in requests {
                            print(request)
                        }
                    })
                    #endif
                }
        }
        .modelContainer(for: [Pet.self])
    }
}
