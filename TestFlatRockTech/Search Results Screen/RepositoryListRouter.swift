//
//  RepositoryListRouter.swift
//  TestFlatRockTech
//

import UIKit

@objc protocol RepositoryListRoutingLogic {
    
}

protocol RepositoryListDataPassing {
    var dataStore: RepositoryListDataStore? { get }
}

class RepositoryListRouter: NSObject, RepositoryListRoutingLogic, RepositoryListDataPassing
{
    weak var viewController: RepositoryListViewController?
    var dataStore: RepositoryListDataStore?
    
}
