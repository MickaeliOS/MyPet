//
//  UNNotificationSettingsExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 14/12/2024.
//

import Foundation
import UserNotifications

extension UNNotificationSettings {
    static var fakeAuthorizationStatus: UNAuthorizationStatus = .authorized

    static func swizzleAuthorizationStatus() {
        let orginalMethod = class_getInstanceMethod(self, #selector(getter: authorizationStatus))!
        let swizzledMethod = class_getInstanceMethod(self, #selector(getter: swizzledAuthorizationStatus))!

        method_exchangeImplementations(orginalMethod, swizzledMethod)
    }

    @objc var swizzledAuthorizationStatus: UNAuthorizationStatus {
        return Self.fakeAuthorizationStatus
    }
}
