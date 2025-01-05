//
//  SwiftDataHelper.swift
//  MyPet
//
//  Created by Mickaël Horn on 20/11/2024.
//

import Foundation
import SwiftData

// MARK: - SWIFT DATA PROTOCOL
protocol SwiftDataProtocol {
    typealias ErrorEnum = SwiftDataHelperError
    func save(with context: ModelContext) throws(SwiftDataHelperError)
}

// MARK: - ENUM
enum SwiftDataHelperError: Error {
    case couldNotSave

    var description: String {
        switch self {
        case .couldNotSave:
            return """
            Oups, la sauvegarde ne s'est pas passée comme prévue, essayez de redémarrer l'application.
            """
        }
    }
}

// MARK: - SWIFT DATA HELPER
struct SwiftDataHelper: SwiftDataProtocol {

    // MARK: FUNCTION
    func save(with context: ModelContext) throws(SwiftDataHelperError) {
        do {
            try context.save()
        } catch {
            throw .couldNotSave
        }
    }
}
