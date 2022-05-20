//
//  IdentifiableObject.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/20/22.
//

import Foundation
import RealmSwift


protocol IdentifiableObject: Object {
    static func primaryKey() -> String
}
