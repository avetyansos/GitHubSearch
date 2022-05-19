//
//  Registerable.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/19/22.
//

import UIKit

protocol Registerable: AnyObject {
    static func nibName() -> String
    static func identifier() -> String
}

extension Registerable {
    static func nibName() -> String {
        return String(describing: self)
    }

    static func identifier() -> String {
        return nibName()
    }
}


extension Registerable where Self: UITableViewCell {

    static func registerNoNib(to tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: identifier())
    }

    static func register(to tableView: UITableView) {
        tableView.register(UINib(nibName: nibName(), bundle: Bundle.main), forCellReuseIdentifier: identifier())
    }

    static func dequeue(from tableView: UITableView) -> Self? {
        return tableView.dequeueReusableCell(withIdentifier: identifier()) as? Self
    }
}
