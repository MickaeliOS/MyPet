//
//  UserDefaultHelperMock.swift
//  MyPetTests
//
//  Created by Mickaël Horn on 14/12/2024.
//

import Foundation
@testable import MyPet

final class UserDefaultHelperMock: UserDefaultHelperProtocol {
    private var content: [String: Int]? = ["badgeCount": 0]

    func value(forKey: String) -> Any? {
        content?[forKey]
    }

    func set(_ value: Int, forKey: String) {
        content?[forKey] = value
    }
}
