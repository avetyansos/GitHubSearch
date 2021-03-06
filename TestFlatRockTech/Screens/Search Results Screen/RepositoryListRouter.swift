//
//  RepositoryListRouter.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryListRoutingLogic {
    func navigateToDetails(owner: String, repoName: String, repoDetailsViewModel: UserRepoViewModel)
}

protocol RepositoryListDataPassing {
    var dataStore: RepositoryListDataStore? { get }
}

class RepositoryListRouter: NSObject, RepositoryListRoutingLogic, RepositoryListDataPassing
{
    weak var viewController: RepositoryListViewController?
    var dataStore: RepositoryListDataStore?
    
    func navigateToDetails(owner: String, repoName: String, repoDetailsViewModel: UserRepoViewModel) {
        let controller = RepositoryDetailsViewController.instantiateFromStoryboard()
        controller.owner = owner
        controller.repoName = repoName
        controller.userReposViewMode = repoDetailsViewModel
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
}
