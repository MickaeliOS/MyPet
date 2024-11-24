//
//  DateExtension.swift
//  MyPet
//
//  Created by Mickaël Horn on 15/08/2024.
//

import Foundation

extension Date {

    // MARK: PROPERTY
    var dateToStringDMY: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
