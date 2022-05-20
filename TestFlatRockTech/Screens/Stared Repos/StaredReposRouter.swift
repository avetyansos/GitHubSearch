//
//  StaredReposRouter.swift
//  TestFlatRockTech
//

import UIKit

protocol StaredReposRoutingLogic {
    func navigateToDetails(owner: String, repoName: String, repoDetailsViewModel: UserRepoViewModel)
}

protocol StaredReposDataPassing {
    var dataStore: StaredReposDataStore? { get }
}

class StaredReposRouter: NSObject, StaredReposRoutingLogic, StaredReposDataPassing
{
    weak var viewController: StaredReposViewController?
    var dataStore: StaredReposDataStore?
    
    
    func navigateToDetails(owner: String, repoName: String, repoDetailsViewModel: UserRepoViewModel) {
        let controller = RepositoryDetailsViewController.instantiateFromStoryboard()
        controller.owner = owner
        controller.repoName = repoName
        controller.userReposViewMode = repoDetailsViewModel
        controller.isSaved = true
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
}
