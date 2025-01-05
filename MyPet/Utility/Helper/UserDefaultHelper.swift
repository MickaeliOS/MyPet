//
//  UserDefaultHelper.swift
//  MyPet
//
//  Created by Mickaël Horn on 13/12/2024.
//

import Foundation

protocol UserDefaultHelperProtocol {
    func value(forKey: String) -> Any?
    func set(_ value: Int, forKey: String)
}

struct UserDefaultHelper: UserDefaultHelperProtocol {
    private let userDefault = UserDefaults.standard

    func value(forKey: String) -> Any? {
        return userDefault.value(forKey: forKey)
    }

    func set(_ value: Int, forKey: String) {
        userDefault.set(value, forKey: forKey)
    }
}
