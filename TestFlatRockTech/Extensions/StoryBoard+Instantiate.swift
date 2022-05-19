//
//  StoryBoard+Instantiate.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/19/22.
//

import UIKit

protocol StringConvertible {
    var rawValue: String { get }
}

protocol Storyboardable: AnyObject {
    static var storyboardName: StringConvertible { get }
}

extension Storyboardable {
    static func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardHelper()
    }

    private static func instantiateFromStoryboardHelper<T>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

// MARK: - String extension
extension String: StringConvertible {
    var rawValue: String {
        return self
    }
}
