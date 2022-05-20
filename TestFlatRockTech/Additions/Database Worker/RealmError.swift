//
//  RealmError.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/20/22.
//

import Foundation


enum RealmError: Error, LocalizedError {
    case realmSchemaMismatch
    case cannotDeleteRealmFile
    case emptyEncryptionKey

    var errorDescription: String? {
        switch self {
        case .realmSchemaMismatch: return "Something went wrong with data"
        case .cannotDeleteRealmFile: return "Soemthing went wrong with Delete"
        case .emptyEncryptionKey: return "Internal error"
        }
    }
}
