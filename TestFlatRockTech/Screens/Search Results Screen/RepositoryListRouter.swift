//
//  RepositoryListRouter.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryListRoutingLogic {
    func navigateToDetails(owner: String, repoName: String)
}

protocol RepositoryListDataPassing {
    var dataStore: RepositoryListDataStore? { get }
}

class RepositoryListRouter: NSObject, RepositoryListRoutingLogic, RepositoryListDataPassing
{
    weak var viewController: RepositoryListViewController?
    var dataStore: RepositoryListDataStore?
    
    func navigateToDetails(owner: String, repoName: String) {
        let controller = RepositoryDetailsViewController.instantiateFromStoryboard()
        controller.owner = owner
        controller.repoName = repoName
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
}
