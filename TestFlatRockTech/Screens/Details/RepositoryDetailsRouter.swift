//
//  RepositoryDetailsRouter.swift
//  TestFlatRockTech
//

import UIKit

@objc protocol RepositoryDetailsRoutingLogic {
    
}

protocol RepositoryDetailsDataPassing {
    var dataStore: RepositoryDetailsDataStore? { get }
}

class RepositoryDetailsRouter: NSObject, RepositoryDetailsRoutingLogic, RepositoryDetailsDataPassing
{
    weak var viewController: RepositoryDetailsViewController?
    var dataStore: RepositoryDetailsDataStore?
    
}
